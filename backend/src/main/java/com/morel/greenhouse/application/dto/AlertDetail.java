package com.morel.greenhouse.application.dto;

import java.time.LocalDateTime;

public record AlertDetail(
        Long id,
        Long greenhouseId,
        String greenhouseName,
        Long deviceId,
        String deviceName,
        String title,
        String description,
        String level,
        String status,
        LocalDateTime occurredAt,
        String handledBy,
        String handleNote,
        LocalDateTime handledAt,
        LocalDateTime resolvedAt
) {
}
