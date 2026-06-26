package com.morel.greenhouse.application.service;

import com.morel.greenhouse.application.dto.DeviceCommandRequest;
import com.morel.greenhouse.application.port.HardwareGateway;
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

    public void execute(DeviceCommandRequest request) {
        hardwareGateway.dispatchDeviceCommand(request);
        String nextStatus = switch (request.command()) {
            case "START" -> "RUNNING";
            case "STOP" -> "STOPPED";
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
}
