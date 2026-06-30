package com.morel.greenhouse.application.dto;

import java.time.LocalDateTime;

public record TelemetryTrendPoint(
        LocalDateTime collectedAt,
        double temperature,
        double humidity,
        int co2Ppm,
        double soilMoisture
) {
}
