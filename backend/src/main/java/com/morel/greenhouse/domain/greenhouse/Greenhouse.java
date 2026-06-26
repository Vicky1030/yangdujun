package com.morel.greenhouse.domain.greenhouse;

public record Greenhouse(
        Long id,
        String name,
        String location,
        GreenhouseStatus status,
        double area,
        String cropStage
) {
}
