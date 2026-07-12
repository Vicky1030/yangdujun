package com.smartgreenhouse.backend.service;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class AuthServicePureLogicTest {
    private final AuthService service = new AuthService();

    @Test
    void privateValidationHelpersShouldHandleBoundaryValues() throws Exception {
        assertTrue(callBoolean("empty", new Class<?>[]{String.class}, (String) null));
        assertTrue(callBoolean("empty", new Class<?>[]{String.class}, "   "));
        assertFalse(callBoolean("empty", new Class<?>[]{String.class}, "abc"));

        assertTrue(callBoolean("validPhone", new Class<?>[]{String.class}, "13800138000"));
        assertFalse(callBoolean("validPhone", new Class<?>[]{String.class}, "23800138000"));
        assertFalse(callBoolean("validPhone", new Class<?>[]{String.class}, "123"));
    }

    @Test
    void passwordAcceptedShouldSupportNoopPlainMd5Sha256AndFarmerShortcut() throws Exception {
        assertTrue(callBoolean("passwordAccepted",
                new Class<?>[]{String.class, String.class, String.class}, "farmer001", "", ""));
        assertTrue(callBoolean("passwordAccepted",
                new Class<?>[]{String.class, String.class, String.class}, "u", "secret", "secret"));
        assertTrue(callBoolean("passwordAccepted",
                new Class<?>[]{String.class, String.class, String.class}, "u", "secret", "{noop}secret"));

        String md5 = callString("md5", new Class<?>[]{String.class}, "secret");
        String sha256 = callString("sha256", new Class<?>[]{String.class}, "secret");
        assertTrue(callBoolean("passwordAccepted",
                new Class<?>[]{String.class, String.class, String.class}, "u", "secret", md5));
        assertTrue(callBoolean("passwordAccepted",
                new Class<?>[]{String.class, String.class, String.class}, "u", "secret", sha256));
        assertFalse(callBoolean("passwordAccepted",
                new Class<?>[]{String.class, String.class, String.class}, "u", "secret", "wrong"));
    }

    @Test
    void normalizeBcryptShouldAcceptKnownPrefixes() throws Exception {
        assertEquals("", callString("normalizeBcrypt", new Class<?>[]{String.class}, (String) null));
        assertEquals("", callString("normalizeBcrypt", new Class<?>[]{String.class}, "plain"));
        assertEquals("$2a$10$abcdefghijklmnopqrstuu",
                callString("normalizeBcrypt", new Class<?>[]{String.class}, "{bcrypt}$2a$10$abcdefghijklmnopqrstuu"));
        assertEquals("$2a$10$abcdefghijklmnopqrstuu",
                callString("normalizeBcrypt", new Class<?>[]{String.class}, "$2y$10$abcdefghijklmnopqrstuu"));
        assertEquals("$2a$10$abcdefghijklmnopqrstuu",
                callString("normalizeBcrypt", new Class<?>[]{String.class}, "$2b$10$abcdefghijklmnopqrstuu"));
    }

    @Test
    void updateFarmerProfileShouldRejectInvalidFieldsBeforeDatabaseUpdate() {
        String emptyName = service.updateFarmerProfile("1", "   ", "13800138000", "");
        String badPhone = service.updateFarmerProfile("1", "tester", "123", "");

        assertTrue(emptyName.contains("\"success\":false"));
        assertTrue(emptyName.contains("nickname cannot be empty"));
        assertTrue(badPhone.contains("\"success\":false"));
        assertTrue(badPhone.contains("invalid phone number"));
    }

    private boolean callBoolean(String name, Class<?>[] types, Object... args) throws Exception {
        return (Boolean) call(name, types, args);
    }

    private String callString(String name, Class<?>[] types, Object... args) throws Exception {
        return (String) call(name, types, args);
    }

    private Object call(String name, Class<?>[] types, Object... args) throws Exception {
        Method method = AuthService.class.getDeclaredMethod(name, types);
        method.setAccessible(true);
        return method.invoke(service, args);
    }
}
