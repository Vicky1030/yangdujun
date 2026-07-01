package com.morel.greenhouse.application.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.morel.greenhouse.shared.exception.BusinessException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
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

        GeneratedTelemetry generated = generateMissingTelemetry(greenhouseId, airTemperature, airHumidity, lightLux);
        jdbcTemplate.update("""
                INSERT INTO telemetry_snapshot(
                    greenhouse_id, temperature, humidity, air_temperature, air_humidity,
                    soil_temperature, soil_humidity, ph_value, light_lux, co2_ppm, soil_moisture, collected_at
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                greenhouseId,
                airTemperature,
                airHumidity,
                airTemperature,
                airHumidity,
                generated.soilTemperature(),
                generated.soilHumidity(),
                generated.phValue(),
                lightLux,
                generated.co2Ppm(),
                generated.soilHumidity(),
                LocalDateTime.now()
        );

        updateDeviceStatus(greenhouseId, data);

        Map<String, Object> result = new HashMap<>();
        result.put("device_id", deviceId);
        result.put("greenhouse_id", greenhouseId);
        result.put("air_temperature", round2(airTemperature));
        result.put("air_humidity", round2(airHumidity));
        result.put("soil_temperature", generated.soilTemperature());
        result.put("soil_humidity", generated.soilHumidity());
        result.put("ph_value", generated.phValue());
        result.put("co2_ppm", generated.co2Ppm());
        result.put("light_lux", lightLux);
        telemetryAlertService.evaluate(greenhouseId, result);
        return result;
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

    private GeneratedTelemetry generateMissingTelemetry(Long greenhouseId, double airTemperature, double airHumidity, int lightLux) {
        double phase = (System.currentTimeMillis() / 60000.0) + greenhouseId * 0.73;
        double soilTemperature = clamp(airTemperature - 1.8 + Math.sin(phase) * 0.45, 16.0, 24.0);
        double soilHumidity = clamp(62.5 + Math.cos(phase / 1.7) * 3.5 + (airHumidity - 75.0) * 0.08, 58.0, 70.0);
        double phValue = clamp(6.7 + Math.sin(phase / 2.3) * 0.12, 6.45, 6.95);
        int co2Ppm = (int) Math.round(clamp(780 + Math.cos(phase / 1.3) * 45 + (lightLux - 4200) * 0.01, 680, 900));
        return new GeneratedTelemetry(round2(soilTemperature), round2(soilHumidity), round2(phValue), co2Ppm);
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

    private double clamp(double value, double min, double max) {
        return Math.max(min, Math.min(max, value));
    }

    private double round2(double value) {
        return Math.round(value * 100.0) / 100.0;
    }

    private record GeneratedTelemetry(
            double soilTemperature,
            double soilHumidity,
            double phValue,
            int co2Ppm
    ) {
    }
}
