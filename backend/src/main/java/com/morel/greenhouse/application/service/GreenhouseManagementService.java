package com.morel.greenhouse.application.service;

import com.morel.greenhouse.application.dto.AlertCommandRequest;
import com.morel.greenhouse.application.dto.CreateDeviceRequest;
import com.morel.greenhouse.application.dto.CreateGreenhouseRequest;
import com.morel.greenhouse.application.dto.HandleAlertRequest;
import com.morel.greenhouse.application.dto.UpdateDeviceRequest;
import com.morel.greenhouse.application.dto.UpdateGreenhouseRequest;
import com.morel.greenhouse.domain.device.DeviceStatus;
import com.morel.greenhouse.domain.greenhouse.GreenhouseStatus;
import com.morel.greenhouse.shared.exception.BusinessException;
import com.morel.greenhouse.shared.security.CurrentUser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class GreenhouseManagementService {
    private static final Logger log = LoggerFactory.getLogger(GreenhouseManagementService.class);
    private final JdbcTemplate jdbcTemplate;

    public GreenhouseManagementService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Transactional
    public void createGreenhouse(CreateGreenhouseRequest request) {
        Integer exists = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM greenhouse WHERE name = ? AND deleted = FALSE",
                Integer.class,
                request.name()
        );
        if (exists != null && exists > 0) {
            throw new BusinessException(409, "大棚名称已存在");
        }
        jdbcTemplate.update("""
                INSERT INTO greenhouse(owner_user_id, name, location, status, area, crop_stage)
                VALUES (?, ?, ?, 'ONLINE', ?, ?)
                """, request.ownerUserId(), request.name(), request.location(), request.area(), request.cropStage());
        Long greenhouseId = jdbcTemplate.queryForObject("SELECT id FROM greenhouse WHERE name = ? ORDER BY id DESC LIMIT 1", Long.class, request.name());
        jdbcTemplate.update("""
                INSERT INTO telemetry_snapshot(greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture)
                VALUES (?, 20.0, 80.0, 3600, 760, 60.0)
                """, greenhouseId);
        if (request.ownerUserId() != null) {
            jdbcTemplate.update("""
                    INSERT INTO farmer_greenhouse_binding(farmer_user_id, greenhouse_id)
                    SELECT ?, ?
                    WHERE NOT EXISTS (
                        SELECT 1 FROM farmer_greenhouse_binding WHERE greenhouse_id = ? AND deleted = FALSE
                    )
                    """, request.ownerUserId(), greenhouseId, greenhouseId);
        }
        log.info("Greenhouse created: id={}, name={}", greenhouseId, request.name());
    }

    @Transactional
    public void updateGreenhouse(Long greenhouseId, UpdateGreenhouseRequest request) {
        ensureGreenhouseExists(greenhouseId);
        String status = normalizeGreenhouseStatus(request.status());
        jdbcTemplate.update("""
                UPDATE greenhouse
                SET owner_user_id = ?, name = ?, location = ?, status = ?, area = ?, crop_stage = ?, updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
                """, request.ownerUserId(), request.name(), request.location(), status, request.area(), request.cropStage(), greenhouseId);
        if (request.ownerUserId() != null) {
            jdbcTemplate.update("UPDATE farmer_greenhouse_binding SET deleted = TRUE, deleted_at = CURRENT_TIMESTAMP WHERE greenhouse_id = ?", greenhouseId);
            jdbcTemplate.update("INSERT INTO farmer_greenhouse_binding(farmer_user_id, greenhouse_id) VALUES (?, ?)", request.ownerUserId(), greenhouseId);
        }
    }

    @Transactional
    public void deleteGreenhouse(Long greenhouseId) {
        ensureGreenhouseExists(greenhouseId);
        Integer openAlerts = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM greenhouse_alert WHERE greenhouse_id = ? AND status <> 'RESOLVED' AND deleted = FALSE",
                Integer.class,
                greenhouseId
        );
        if (openAlerts != null && openAlerts > 0) {
            throw new BusinessException(409, "该大棚仍有未解决告警，请先完成处理闭环");
        }
        jdbcTemplate.update("UPDATE farmer_greenhouse_binding SET deleted = TRUE, deleted_at = CURRENT_TIMESTAMP WHERE greenhouse_id = ?", greenhouseId);
        jdbcTemplate.update("UPDATE greenhouse_device SET deleted = TRUE, deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE greenhouse_id = ?", greenhouseId);
        jdbcTemplate.update("UPDATE greenhouse SET deleted = TRUE, deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = ?", greenhouseId);
    }

    @Transactional
    public void createDevice(CreateDeviceRequest request, CurrentUser currentUser) {
        ensureFarmerCanManageGreenhouse(request.greenhouseId(), currentUser);
        jdbcTemplate.update("""
                INSERT INTO greenhouse_device(greenhouse_id, name, category, status, location, remark, auto_mode, health_score)
                VALUES (?, ?, ?, 'STOPPED', ?, ?, ?, 100)
                """, request.greenhouseId(), request.name(), request.category(), request.location(), request.remark(), Boolean.TRUE.equals(request.autoMode()));
    }

    @Transactional
    public void updateDevice(Long deviceId, UpdateDeviceRequest request, CurrentUser currentUser) {
        ensureDeviceExists(deviceId);
        ensureFarmerCanManageGreenhouse(request.greenhouseId(), currentUser);
        Long currentGreenhouseId = jdbcTemplate.queryForObject("SELECT greenhouse_id FROM greenhouse_device WHERE id = ? AND deleted = FALSE", Long.class, deviceId);
        ensureFarmerCanManageGreenhouse(currentGreenhouseId, currentUser);
        jdbcTemplate.update("""
                UPDATE greenhouse_device
                SET greenhouse_id = ?, name = ?, category = ?, status = ?, location = ?, remark = ?, auto_mode = ?, health_score = ?, updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
                """, request.greenhouseId(), request.name(), request.category(), normalizeDeviceStatus(request.status()),
                request.location(), request.remark(), Boolean.TRUE.equals(request.autoMode()), request.healthScore(), deviceId);
    }

    @Transactional
    public void deleteDevice(Long deviceId, CurrentUser currentUser) {
        ensureDeviceExists(deviceId);
        Long greenhouseId = jdbcTemplate.queryForObject("SELECT greenhouse_id FROM greenhouse_device WHERE id = ? AND deleted = FALSE", Long.class, deviceId);
        ensureFarmerCanManageGreenhouse(greenhouseId, currentUser);
        Integer openAlerts = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM greenhouse_alert WHERE device_id = ? AND status <> 'RESOLVED' AND deleted = FALSE",
                Integer.class,
                deviceId
        );
        if (openAlerts != null && openAlerts > 0) {
            throw new BusinessException(409, "该设备仍有关联未解决告警，请先处理告警后再删除");
        }
        jdbcTemplate.update("UPDATE greenhouse_device SET deleted = TRUE, deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = ?", deviceId);
    }

    @Transactional
    public void handleAlert(Long alertId, HandleAlertRequest request, CurrentUser currentUser) {
        ensureAlertVisible(alertId, currentUser);
        String nextStatus = request.status().trim().toUpperCase();
        if (!"ACKNOWLEDGED".equals(nextStatus) && !"RESOLVED".equals(nextStatus)) {
            throw new BusinessException(400, "告警只能确认或解决");
        }
        String note = request.note() == null ? "" : request.note().trim();
        if ("RESOLVED".equals(nextStatus) && note.isBlank()) {
            throw new BusinessException(400, "解决告警时需要填写处理意见");
        }
        String handler = request.handler() == null || request.handler().isBlank() ? currentUser.username() : request.handler().trim();
        jdbcTemplate.update("""
                UPDATE greenhouse_alert
                SET status = ?, handled_by = ?, handle_note = ?, handled_at = CURRENT_TIMESTAMP,
                    resolved_at = CASE WHEN ? = 'RESOLVED' THEN CURRENT_TIMESTAMP ELSE resolved_at END,
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
                """, nextStatus, handler, note, nextStatus, alertId);
    }

    @Transactional
    public void recordAlertCommand(Long alertId, AlertCommandRequest request, String operator) {
        ensureAlertExists(alertId);
        jdbcTemplate.update("""
                INSERT INTO alert_action_log(alert_id, device_id, command, notify_user_id, operator, action_note)
                SELECT ?, ?, ?, g.owner_user_id, ?, ?
                FROM greenhouse_alert a
                JOIN greenhouse g ON g.id = a.greenhouse_id
                WHERE a.id = ?
                """, alertId, request.deviceId(), request.command(), operator, request.note(), alertId);
        if (Boolean.TRUE.equals(request.notifyFarmer())) {
            jdbcTemplate.update("""
                    INSERT INTO feedback(user_id, category, content, contact)
                    SELECT g.owner_user_id, '告警通知', ?, ?
                    FROM greenhouse_alert a
                    JOIN greenhouse g ON g.id = a.greenhouse_id
                    WHERE a.id = ? AND g.owner_user_id IS NOT NULL
                    """, "管理员已处理告警并下发设备命令：" + request.command() + "。" + (request.note() == null ? "" : request.note()), operator, alertId);
        }
    }

    private void ensureFarmerCanManageGreenhouse(Long greenhouseId, CurrentUser currentUser) {
        ensureGreenhouseExists(greenhouseId);
        if (currentUser == null) {
            throw new BusinessException(401, "请先登录");
        }
        if (currentUser.admin()) {
            throw new BusinessException(403, "管理员只能查看设备，不能新增、修改或删除设备");
        }
        Integer allowed = jdbcTemplate.queryForObject("""
                SELECT COUNT(1)
                FROM farmer_greenhouse_binding
                WHERE greenhouse_id = ? AND farmer_user_id = ? AND deleted = FALSE
                """, Integer.class, greenhouseId, currentUser.id());
        if (allowed == null || allowed == 0) {
            throw new BusinessException(403, "只能管理自己绑定大棚的设备");
        }
    }

    private void ensureAlertVisible(Long alertId, CurrentUser currentUser) {
        ensureAlertExists(alertId);
        if (currentUser == null || currentUser.admin()) {
            return;
        }
        Integer allowed = jdbcTemplate.queryForObject("""
                SELECT COUNT(1)
                FROM greenhouse_alert a
                JOIN farmer_greenhouse_binding b ON b.greenhouse_id = a.greenhouse_id AND b.deleted = FALSE
                WHERE a.id = ? AND b.farmer_user_id = ?
                """, Integer.class, alertId, currentUser.id());
        if (allowed == null || allowed == 0) {
            throw new BusinessException(403, "只能处理自己大棚的告警");
        }
    }

    private void ensureGreenhouseExists(Long greenhouseId) {
        Integer exists = jdbcTemplate.queryForObject("SELECT COUNT(1) FROM greenhouse WHERE id = ? AND deleted = FALSE", Integer.class, greenhouseId);
        if (exists == null || exists == 0) throw new BusinessException(404, "大棚不存在");
    }

    private void ensureDeviceExists(Long deviceId) {
        Integer exists = jdbcTemplate.queryForObject("SELECT COUNT(1) FROM greenhouse_device WHERE id = ? AND deleted = FALSE", Integer.class, deviceId);
        if (exists == null || exists == 0) throw new BusinessException(404, "设备不存在");
    }

    private void ensureAlertExists(Long alertId) {
        Integer exists = jdbcTemplate.queryForObject("SELECT COUNT(1) FROM greenhouse_alert WHERE id = ? AND deleted = FALSE", Integer.class, alertId);
        if (exists == null || exists == 0) throw new BusinessException(404, "告警不存在");
    }

    private String normalizeGreenhouseStatus(String status) {
        try {
            return GreenhouseStatus.valueOf(status.trim().toUpperCase()).name();
        } catch (RuntimeException ex) {
            throw new BusinessException(400, "大棚状态只能是在线、预警或离线");
        }
    }

    private String normalizeDeviceStatus(String status) {
        try {
            return DeviceStatus.valueOf(status.trim().toUpperCase()).name();
        } catch (RuntimeException ex) {
            throw new BusinessException(400, "设备状态只能是运行、停止或维护");
        }
    }
}
