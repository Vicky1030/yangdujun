package com.morel.greenhouse.domain.telemetry;

import java.time.LocalDateTime;

public record TelemetrySnapshot(
        Long greenhouseId,
        double temperature,
        double humidity,
        int lightLux,
        int co2Ppm,
        double soilMoisture,
        LocalDateTime collectedAt
) {
}
