package com.smartgreenhouse.backend.service;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

class AuthServiceTest {
    private final AuthService service = new AuthService();

    @Test
    void loginFarmerShouldRejectEmptyAccountBeforeDatabaseAccess() {
        String result = service.loginFarmer("", "abc12345");

        assertTrue(result.contains("\"success\":false"));
        assertTrue(result.contains("account required"));
    }

    @Test
    void registerFarmerShouldRejectInvalidPhoneBeforeDatabaseAccess() {
        String result = service.registerFarmer("123", "abc12345");

        assertTrue(result.contains("\"success\":false"));
        assertTrue(result.contains("invalid phone or password"));
    }

    @Test
    void registerFarmerShouldRejectWeakPasswordBeforeDatabaseAccess() {
        String result = service.registerFarmer("13800138000", "123");

        assertTrue(result.contains("\"success\":false"));
        assertTrue(result.contains("invalid phone or password"));
    }

    @Test
    void resetFarmerPasswordShouldRejectInvalidPhoneBeforeDatabaseAccess() {
        String result = service.resetFarmerPassword("abc", "abc12345");

        assertTrue(result.contains("\"success\":false"));
        assertTrue(result.contains("invalid phone or password"));
    }

    @Test
    void resetFarmerPasswordShouldRejectWeakPasswordBeforeDatabaseAccess() {
        String result = service.resetFarmerPassword("13800138000", "123");

        assertTrue(result.contains("\"success\":false"));
        assertTrue(result.contains("invalid phone or password"));
    }
}
