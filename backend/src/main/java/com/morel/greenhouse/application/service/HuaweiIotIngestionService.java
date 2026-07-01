package com.morel.greenhouse.application.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.morel.greenhouse.shared.exception.BusinessException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Service
public class HuaweiIotIngestionService {
    private final JdbcTemplate jdbcTemplate;
    private final TelemetryAlertService telemetryAlertService;
    private final String defaultDeviceId;
    private final String deviceGreenhouseMap;

    public HuaweiIotIngestionService(
            JdbcTemplate jdbcTemplate,
            TelemetryAlertService telemetryAlertService,
            @Value("${greenhouse.iot.huawei.default-device-id:}") String defaultDeviceId,
            @Value("${greenhouse.iot.huawei.device-greenhouse-map:}") String deviceGreenhouseMap
    ) {
        this.jdbcTemplate = jdbcTemplate;
        this.telemetryAlertService = telemetryAlertService;
        this.defaultDeviceId = defaultDeviceId;
        this.deviceGreenhouseMap = deviceGreenhouseMap;
    }

    @Transactional
    public Map<String, Object> ingest(JsonNode payload) {
        if (payload == null || payload.isNull()) {
            throw new BusinessException(400, "华为云上报数据不能为空");
        }
        String deviceId = firstText(payload, "device_id", "deviceId", "node_id", "nodeId");
        if (deviceId == null) {
            deviceId = firstText(payload.at("/notify_data/header"), "device_id", "deviceId", "node_id", "nodeId");
        }
        if (deviceId == null || deviceId.isBlank()) {
            deviceId = defaultDeviceId;
        }
        if (deviceId == null || deviceId.isBlank()) {
            throw new BusinessException(400, "缺少华为云 device_id");
        }

        JsonNode data = payload.path("data");
        if (data.isMissingNode() || data.isNull()) {
            data = payload.path("properties");
        }
        if (data.isMissingNode() || data.isNull()) {
            data = payload.at("/notify_data/body/services/0/properties");
        }
        if (data.isMissingNode() || data.isNull()) {
            throw new BusinessException(400, "缺少传感器 data/properties 数据");
        }

        Long greenhouseId = resolveGreenhouseId(deviceId);
        double airTemperature = requiredDouble(data, "Temp", "temperature", "airTemperature");
        double airHumidity = requiredDouble(data, "Humi", "humidity", "airHumidity");
        int lightLux = normalizeLightLux(optionalDouble(data, "Lumi", "light", "lightLux"));

        Map<String, Object> latest = latestTelemetry(greenhouseId);
        double soilTemperature = round2(valueOrLatest(optionalDouble(data, "SoilTemp", "soilTemperature", "soil_temperature"), latest, "soil_temperature", 20.0));
        double soilHumidity = round2(valueOrLatest(optionalDouble(data, "SoilHumi", "soilHumidity", "soil_humidity", "soil_moisture"), latest, "soil_humidity", 60.0));
        double phValue = round2(valueOrLatest(optionalDouble(data, "PH", "Ph", "pH", "ph", "phValue", "ph_value"), latest, "ph_value", 6.70));
        int co2Ppm = (int) Math.round(valueOrLatest(optionalDouble(data, "CO2", "co2", "co2Ppm", "co2_ppm"), latest, "co2_ppm", 760.0));
        upsertCurrentTelemetry(
                greenhouseId,
                airTemperature,
                airHumidity,
                soilTemperature,
                soilHumidity,
                phValue,
                lightLux,
                co2Ppm
        );

        updateDeviceStatus(greenhouseId, data);

        Map<String, Object> result = new HashMap<>();
        result.put("device_id", deviceId);
        result.put("greenhouse_id", greenhouseId);
        result.put("air_temperature", round2(airTemperature));
        result.put("air_humidity", round2(airHumidity));
        result.put("soil_temperature", soilTemperature);
        result.put("soil_humidity", soilHumidity);
        result.put("ph_value", phValue);
        result.put("co2_ppm", co2Ppm);
        result.put("light_lux", lightLux);
        telemetryAlertService.evaluate(greenhouseId, result);
        return result;
    }

    private void upsertCurrentTelemetry(
            Long greenhouseId,
            double airTemperature,
            double airHumidity,
            double soilTemperature,
            double soilHumidity,
            double phValue,
            int lightLux,
            int co2Ppm
    ) {
        Long latestId = jdbcTemplate.query("""
                SELECT id
                FROM telemetry_snapshot
                WHERE greenhouse_id = ?
                ORDER BY collected_at DESC, id DESC
                LIMIT 1
                """, rs -> rs.next() ? rs.getLong("id") : null, greenhouseId);
        if (latestId == null) {
            jdbcTemplate.update("""
                    INSERT INTO telemetry_snapshot(
                        greenhouse_id, temperature, humidity, air_temperature, air_humidity,
                        soil_temperature, soil_humidity, ph_value, light_lux, co2_ppm, soil_moisture
                    )
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """,
                    greenhouseId, airTemperature, airHumidity, airTemperature, airHumidity,
                    soilTemperature, soilHumidity, phValue, lightLux, co2Ppm, soilHumidity);
            return;
        }
        jdbcTemplate.update("""
                UPDATE telemetry_snapshot
                SET temperature = ?,
                    humidity = ?,
                    air_temperature = ?,
                    air_humidity = ?,
                    soil_temperature = ?,
                    soil_humidity = ?,
                    ph_value = ?,
                    light_lux = ?,
                    co2_ppm = ?,
                    soil_moisture = ?,
                    collected_at = CURRENT_TIMESTAMP
                WHERE id = ?
                """,
                airTemperature, airHumidity, airTemperature, airHumidity,
                soilTemperature, soilHumidity, phValue, lightLux, co2Ppm, soilHumidity, latestId);
    }

    private Map<String, Object> latestTelemetry(Long greenhouseId) {
        return jdbcTemplate.queryForList("""
                SELECT soil_temperature, soil_humidity, ph_value, co2_ppm
                FROM telemetry_snapshot
                WHERE greenhouse_id = ?
                ORDER BY collected_at DESC, id DESC
                LIMIT 1
                """, greenhouseId).stream().findFirst().orElse(Map.of());
    }

    private Long resolveGreenhouseId(String deviceId) {
        Long mapped = mappedGreenhouseId(deviceId);
        if (mapped != null) {
            ensureGreenhouseExists(mapped);
            return mapped;
        }
        Long fromDevice = jdbcTemplate.query("""
                SELECT greenhouse_id
                FROM greenhouse_device
                WHERE serial_no = ? AND deleted = FALSE
                ORDER BY id DESC
                LIMIT 1
                """, rs -> rs.next() ? rs.getLong("greenhouse_id") : null, deviceId);
        if (fromDevice != null) {
            return fromDevice;
        }
        throw new BusinessException(404, "未找到华为云设备对应的大棚：" + deviceId);
    }

    private Long mappedGreenhouseId(String deviceId) {
        if (deviceGreenhouseMap == null || deviceGreenhouseMap.isBlank()) {
            return null;
        }
        for (String pair : deviceGreenhouseMap.split(",")) {
            String[] parts = pair.split(":", 2);
            if (parts.length == 2 && parts[0].trim().equals(deviceId)) {
                try {
                    return Long.valueOf(parts[1].trim());
                } catch (NumberFormatException ignored) {
                    throw new BusinessException(500, "华为云设备映射配置错误：" + pair);
                }
            }
        }
        return null;
    }

    private void ensureGreenhouseExists(Long greenhouseId) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM greenhouse WHERE id = ? AND deleted = FALSE",
                Integer.class,
                greenhouseId
        );
        if (count == null || count == 0) {
            throw new BusinessException(404, "配置的大棚不存在：" + greenhouseId);
        }
    }

    private void updateDeviceStatus(Long greenhouseId, JsonNode data) {
        String lampStatus = firstText(data, "LampST", "lampStatus");
        if (lampStatus != null && !lampStatus.isBlank()) {
            jdbcTemplate.update("""
                    UPDATE greenhouse_device
                    SET status = ?, updated_at = CURRENT_TIMESTAMP
                    WHERE greenhouse_id = ? AND deleted = FALSE AND category LIKE '%补光%'
                    """, "ON".equalsIgnoreCase(lampStatus) ? "RUNNING" : "STOPPED", greenhouseId);
        }
        Double fanLevel = optionalDouble(data, "Fengd", "fanLevel");
        if (fanLevel != null) {
            jdbcTemplate.update("""
                    UPDATE greenhouse_device
                    SET status = ?, updated_at = CURRENT_TIMESTAMP
                    WHERE greenhouse_id = ? AND deleted = FALSE AND (category LIKE '%通风%' OR name LIKE '%风机%')
                    """, fanLevel > 0 ? "RUNNING" : "STOPPED", greenhouseId);
        }
    }

    private String firstText(JsonNode node, String... names) {
        if (node == null || node.isMissingNode() || node.isNull()) {
            return null;
        }
        for (String name : names) {
            JsonNode value = node.get(name);
            if (value != null && !value.isNull()) {
                String text = value.asText();
                if (text != null && !text.isBlank()) {
                    return text.trim();
                }
            }
        }
        return null;
    }

    private double requiredDouble(JsonNode data, String... names) {
        Double value = optionalDouble(data, names);
        if (value == null) {
            throw new BusinessException(400, "缺少必要传感器字段：" + String.join("/", names));
        }
        return round2(value);
    }

    private Double optionalDouble(JsonNode data, String... names) {
        String text = firstText(data, names);
        if (text == null) {
            return null;
        }
        try {
            return Double.valueOf(text);
        } catch (NumberFormatException ignored) {
            throw new BusinessException(400, "传感器字段不是有效数字：" + String.join("/", names));
        }
    }

    private int normalizeLightLux(Double raw) {
        if (raw == null) {
            return 4200;
        }
        if (raw <= 100) {
            return (int) Math.round(raw * 70);
        }
        return (int) Math.round(raw);
    }

    private double valueOrLatest(Double current, Map<String, Object> latest, String latestKey, double fallback) {
        if (current != null) {
            return current;
        }
        Object value = latest.get(latestKey);
        if (value instanceof Number number) {
            return number.doubleValue();
        }
        if (value != null) {
            try {
                return Double.parseDouble(String.valueOf(value));
            } catch (NumberFormatException ignored) {
                return fallback;
            }
        }
        return fallback;
    }

    private double round2(double value) {
        return Math.round(value * 100.0) / 100.0;
    }
}
