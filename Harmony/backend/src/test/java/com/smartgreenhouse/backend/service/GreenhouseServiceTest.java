package com.smartgreenhouse.backend.service;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

class GreenhouseServiceTest {
    private final GreenhouseService service = new GreenhouseService();

    @Test
    void saveThresholdShouldRejectBlankGreenhouseIdBeforeDatabaseAccess() {
        String result = service.saveThreshold("", "{}");

        assertTrue(result.contains("\"success\":false"));
        assertTrue(result.contains("invalid greenhouse id"));
    }

    @Test
    void saveThresholdShouldRejectNonNumericGreenhouseIdBeforeDatabaseAccess() {
        String result = service.saveThreshold("abc", "{}");

        assertTrue(result.contains("\"success\":false"));
        assertTrue(result.contains("invalid greenhouse id"));
    }
}
