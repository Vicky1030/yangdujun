package com.morel.greenhouse.application.service;

import com.morel.greenhouse.application.dto.DeviceCommandRequest;
import com.morel.greenhouse.application.port.HardwareGateway;
import com.morel.greenhouse.shared.exception.BusinessException;
import com.morel.greenhouse.shared.security.CurrentUser;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class DeviceCommandService {
    private final HardwareGateway hardwareGateway;
    private final JdbcTemplate jdbcTemplate;

    public DeviceCommandService(HardwareGateway hardwareGateway, JdbcTemplate jdbcTemplate) {
        this.hardwareGateway = hardwareGateway;
        this.jdbcTemplate = jdbcTemplate;
    }

    public void execute(DeviceCommandRequest request, CurrentUser currentUser) {
        ensureCanCommandDevice(request.deviceId(), currentUser);
        hardwareGateway.dispatchDeviceCommand(request);
        String nextStatus = switch (request.command()) {
            case "START" -> "RUNNING";
            case "STOP" -> "STOPPED";
            case "MAINTENANCE" -> "MAINTENANCE";
            default -> null;
        };
        if (nextStatus != null) {
            jdbcTemplate.update("""
                    UPDATE greenhouse_device
                    SET status = ?, last_command = ?, updated_at = CURRENT_TIMESTAMP
                    WHERE id = ?
            """, nextStatus, request.command(), request.deviceId());
        }
    }

    private void ensureCanCommandDevice(Long deviceId, CurrentUser currentUser) {
        if (currentUser == null) {
            throw new BusinessException(401, "请先登录");
        }
        Integer exists = jdbcTemplate.queryForObject("""
                SELECT COUNT(1)
                FROM greenhouse_device
                WHERE id = ? AND deleted = FALSE
                """, Integer.class, deviceId);
        if (exists == null || exists == 0) {
            throw new BusinessException(404, "设备不存在");
        }
        if (currentUser.admin()) {
            return;
        }
        Integer allowed = jdbcTemplate.queryForObject("""
                SELECT COUNT(1)
                FROM greenhouse_device d
                JOIN greenhouse g ON g.id = d.greenhouse_id AND g.deleted = FALSE
                LEFT JOIN farmer_greenhouse_binding b ON b.greenhouse_id = g.id AND b.deleted = FALSE
                WHERE d.id = ?
                  AND d.deleted = FALSE
                  AND (g.owner_user_id = ? OR b.farmer_user_id = ?)
                """, Integer.class, deviceId, currentUser.id(), currentUser.id());
        if (allowed == null || allowed == 0) {
            throw new BusinessException(403, "只能调控自己大棚的设备");
        }
    }
}
