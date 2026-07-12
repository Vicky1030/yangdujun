package com.smartgreenhouse.backend.service;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class DeepSeekServiceTest {
    private final DeepSeekService service = new DeepSeekService();

    @Test
    void chatShouldRejectBlankQuestionAndHandleMissingApiKey() {
        assertTrue(service.chat("", "").contains("answer"));
        assertTrue(service.chat("how to grow?", "").contains("answer"));
    }

    @Test
    void suggestionShouldHandleBlankPromptWithoutNetworkWhenApiKeyMissing() {
        assertTrue(service.suggestion("").contains("suggestion"));
    }

    @Test
    void privateHelpersShouldNormalizeText() throws Exception {
        assertEquals("", callString("value", new Class<?>[]{String.class}, (String) null));
        assertEquals("abc", callString("value", new Class<?>[]{String.class}, "abc"));
        assertEquals("line one line two", callString("summarize", new Class<?>[]{String.class}, "line one\nline two"));
        assertTrue(callString("summarize", new Class<?>[]{String.class}, repeat("a", 220)).length() <= 180);
    }

    private String callString(String name, Class<?>[] types, Object... args) throws Exception {
        Method method = DeepSeekService.class.getDeclaredMethod(name, types);
        method.setAccessible(true);
        return (String) method.invoke(service, args);
    }

    private String repeat(String value, int count) {
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < count; i++) {
            builder.append(value);
        }
        return builder.toString();
    }
}
