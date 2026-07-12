package com.smartgreenhouse.backend.util;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class JsonTest {
    @Test
    void escapeShouldHandleNullPlainTextAndSpecialCharacters() {
        assertEquals("", Json.escape(null));
        assertEquals("abc", Json.escape("abc"));
        assertEquals("\\\"", Json.escape("\""));
        assertEquals("\\\\", Json.escape("\\"));
        assertEquals("a\\nb\\rc\\td", Json.escape("a\nb\rc\td"));
    }

    @Test
    void extractStringShouldReturnStringValueAndFallback() {
        String json = "{\"name\":\"tom\",\"message\":\"hello\\nworld\",\"quote\":\"a\\\"b\"}";

        assertEquals("tom", Json.extractString(json, "name", ""));
        assertEquals("hello\nworld", Json.extractString(json, "message", ""));
        assertEquals("a\"b", Json.extractString(json, "quote", ""));
        assertEquals("fallback", Json.extractString(json, "missing", "fallback"));
        assertEquals("fallback", Json.extractString(null, "name", "fallback"));
    }

    @Test
    void extractValueShouldReturnStringNumberBooleanAndFallback() {
        String json = "{\"age\":18,\"enabled\":true,\"name\":\"tom\"}";

        assertEquals("18", Json.extractValue(json, "age", ""));
        assertEquals("true", Json.extractValue(json, "enabled", ""));
        assertEquals("tom", Json.extractValue(json, "name", ""));
        assertEquals("fallback", Json.extractValue(json, "missing", "fallback"));
        assertEquals("fallback", Json.extractValue(null, "name", "fallback"));
    }
}
