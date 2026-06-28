package com.morel.greenhouse.application.service;

import com.morel.greenhouse.application.dto.CreateDeviceRequest;
import com.morel.greenhouse.application.dto.CreateGreenhouseRequest;
import com.morel.greenhouse.application.dto.HandleAlertRequest;
import com.morel.greenhouse.shared.exception.BusinessException;
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
                "SELECT COUNT(1) FROM greenhouse WHERE name = ?",
                Integer.class,
                request.name()
        );
        if (exists != null && exists > 0) {
            throw new BusinessException(409, "大棚名称已存在");
        }
        jdbcTemplate.update("""
                INSERT INTO greenhouse(owner_user_id, name, location, status, area, crop_stage)
                VALUES (?, ?, ?, 'ONLINE', ?, ?)
                """,
                request.ownerUserId(),
                request.name(),
                request.location(),
                request.area(),
                request.cropStage()
        );
        Long greenhouseId = jdbcTemplate.queryForObject(
                "SELECT id FROM greenhouse WHERE name = ? ORDER BY id DESC LIMIT 1",
                Long.class,
                request.name()
        );
        jdbcTemplate.update("""
                INSERT INTO telemetry_snapshot(greenhouse_id, temperature, humidity, light_lux, co2_ppm, soil_moisture)
                VALUES (?, 20.0, 80.0, 3600, 760, 60.0)
                """, greenhouseId);
        log.info("Greenhouse created: id={}, name={}, location={}", greenhouseId, request.name(), request.location());
    }

    public void createDevice(CreateDeviceRequest request) {
        Integer greenhouseExists = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM greenhouse WHERE id = ?",
                Integer.class,
                request.greenhouseId()
        );
        if (greenhouseExists == null || greenhouseExists == 0) {
            throw new BusinessException(404, "绑定的大棚不存在");
        }
        jdbcTemplate.update("""
                INSERT INTO greenhouse_device(greenhouse_id, name, category, status, location, auto_mode, health_score)
                VALUES (?, ?, ?, 'STOPPED', ?, ?, 100)
                """,
                request.greenhouseId(),
                request.name(),
                request.category(),
                request.location(),
                Boolean.TRUE.equals(request.autoMode())
        );
        log.info("Device created: greenhouseId={}, name={}, category={}", request.greenhouseId(), request.name(), request.category());
    }

    @Transactional
    public void handleAlert(Long alertId, HandleAlertRequest request) {
        String nextStatus = request.status().trim().toUpperCase();
        if (!"ACKNOWLEDGED".equals(nextStatus) && !"RESOLVED".equals(nextStatus)) {
            throw new BusinessException(400, "告警只能确认或解决");
        }
        Integer exists = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM greenhouse_alert WHERE id = ?",
                Integer.class,
                alertId
        );
        if (exists == null || exists == 0) {
            throw new BusinessException(404, "告警不存在");
        }
        String note = request.note() == null ? "" : request.note().trim();
        if ("RESOLVED".equals(nextStatus) && note.isBlank()) {
            throw new BusinessException(400, "解决告警时需要填写处理意见");
        }
        jdbcTemplate.update("""
                UPDATE greenhouse_alert
                SET status = ?,
                    handled_by = ?,
                    handle_note = ?,
                    handled_at = CURRENT_TIMESTAMP,
                    resolved_at = CASE WHEN ? = 'RESOLVED' THEN CURRENT_TIMESTAMP ELSE resolved_at END
                WHERE id = ?
                """,
                nextStatus,
                request.handler().trim(),
                note,
                nextStatus,
                alertId
        );
        log.info("Alert handled: id={}, status={}, handler={}", alertId, nextStatus, request.handler());
    }
}
