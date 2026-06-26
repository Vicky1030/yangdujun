package com.morel.greenhouse.application.dto;

public record ProductionSummary(
        int activeGreenhouseCount,
        int runningDeviceCount,
        int unresolvedAlertCount,
        double expectedYieldKg,
        String qualityGrade
) {
}
