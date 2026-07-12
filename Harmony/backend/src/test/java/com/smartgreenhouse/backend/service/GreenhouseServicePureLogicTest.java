package com.smartgreenhouse.backend.service;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class GreenhouseServicePureLogicTest {
    private final GreenhouseService service = new GreenhouseService();

    @Test
    void thresholdHelpersShouldProduceDefaultsAndApplyMetricOverrides() throws Exception {
        double[] values = callDoubleArray("defaultThresholdValues", new Class<?>[]{});
        assertEquals(16.0, values[0]);
        assertEquals(24.0, values[1]);
        assertEquals(6000.0, values[15]);

        callVoid("applyThreshold", new Class<?>[]{double[].class, String.class, String.class, double.class},
                values, "air_temperature", "LT", 12.5);
        callVoid("applyThreshold", new Class<?>[]{double[].class, String.class, String.class, double.class},
                values, "co2", ">", 1200.0);
        callVoid("applyThreshold", new Class<?>[]{double[].class, String.class, String.class, double.class},
                values, "ph", "GT", 7.4);
        assertEquals(12.5, values[0]);
        assertEquals(1200.0, values[9]);
        assertEquals(7.4, values[13]);

        String json = callString("thresholdJson", new Class<?>[]{double[].class}, (Object) values);
        assertTrue(json.contains("\"tempMin\":12.5"));
        assertTrue(json.contains("\"co2Max\":1200.0"));
        assertTrue(json.contains("\"phMax\":7.4"));
    }

    @Test
    void numericHelpersShouldUseFallbackForInvalidValues() throws Exception {
        assertEquals(12L, callLong("longValue", new Class<?>[]{String.class, long.class}, "12", -1L));
        assertEquals(-1L, callLong("longValue", new Class<?>[]{String.class, long.class}, "abc", -1L));
        assertEquals(3.14, callDouble("doubleValue", new Class<?>[]{String.class, double.class}, "3.14", -1.0));
        assertEquals(-1.0, callDouble("doubleValue", new Class<?>[]{String.class, double.class}, "bad", -1.0));
        assertEquals(1.2, callDouble("round1", new Class<?>[]{double.class}, 1.24));
        assertEquals(1.24, callDouble("round2", new Class<?>[]{double.class}, 1.236));
    }

    @Test
    void jsonDoubleShouldReadNumbersAndFallback() throws Exception {
        String body = "{\"tempMin\":12.5,\"bad\":\"abc\"}";

        assertEquals(12.5, callDouble("jsonDouble", new Class<?>[]{String.class, String.class, double.class},
                body, "tempMin", 16.0));
        assertEquals(16.0, callDouble("jsonDouble", new Class<?>[]{String.class, String.class, double.class},
                body, "bad", 16.0));
        assertEquals(16.0, callDouble("jsonDouble", new Class<?>[]{String.class, String.class, double.class},
                body, "missing", 16.0));
    }

    @Test
    void sqlShouldEscapeQuotes() throws Exception {
        assertEquals("", callString("sql", new Class<?>[]{String.class}, (String) null));
        assertEquals("A''B", callString("sql", new Class<?>[]{String.class}, "A'B"));
    }

    @Test
    void deviceHelpersShouldClassifyTypesIdsAndEnabledState() throws Exception {
        assertEquals("fan", callString("deviceType", new Class<?>[]{String.class, String.class}, "FAN", ""));
        assertEquals("light", callString("deviceType", new Class<?>[]{String.class, String.class}, "LIGHT", ""));
        assertEquals("board", callString("deviceType", new Class<?>[]{String.class, String.class}, "BOARD", ""));
        assertEquals("water", callString("deviceType", new Class<?>[]{String.class, String.class}, "PUMP", ""));
        assertEquals("sensor", callString("deviceType", new Class<?>[]{String.class, String.class}, "OTHER", "sensor"));

        assertEquals("light_1", callString("baseDeviceId", new Class<?>[]{String.class, String.class}, "light", "7"));
        assertEquals("board_1", callString("baseDeviceId", new Class<?>[]{String.class, String.class}, "board", "7"));
        assertEquals("fan_1", callString("baseDeviceId", new Class<?>[]{String.class, String.class}, "fan", "7"));
        assertEquals("water_pump_1", callString("baseDeviceId", new Class<?>[]{String.class, String.class}, "water", "7"));
        assertEquals("medicine_pump_1", callString("baseDeviceId", new Class<?>[]{String.class, String.class}, "medicine", "7"));
        assertEquals("sensor_7", callString("baseDeviceId", new Class<?>[]{String.class, String.class}, "sensor", "7"));

        assertTrue(callBoolean("isDeviceEnabled", new Class<?>[]{String.class}, "RUNNING"));
        assertTrue(callBoolean("isDeviceEnabled", new Class<?>[]{String.class}, "online"));
        assertTrue(callBoolean("isDeviceEnabled", new Class<?>[]{String.class}, "ON"));
        assertFalse(callBoolean("isDeviceEnabled", new Class<?>[]{String.class}, "OFF"));
    }

    @Test
    void labelsShouldMapKnownStatusAndLevelValues() throws Exception {
        assertTrue(callString("statusLabel", new Class<?>[]{String.class}, "RESOLVED").length() > 0);
        assertTrue(callString("statusLabel", new Class<?>[]{String.class}, "ACTIVE").length() > 0);
        assertTrue(callString("levelLabel", new Class<?>[]{String.class}, "CRITICAL").length() > 0);
        assertTrue(callString("levelLabel", new Class<?>[]{String.class}, "INFO").length() > 0);
        assertTrue(callString("levelLabel", new Class<?>[]{String.class}, "WARNING").length() > 0);
    }

    private double[] callDoubleArray(String name, Class<?>[] types, Object... args) throws Exception {
        return (double[]) call(name, types, args);
    }

    private void callVoid(String name, Class<?>[] types, Object... args) throws Exception {
        call(name, types, args);
    }

    private boolean callBoolean(String name, Class<?>[] types, Object... args) throws Exception {
        return (Boolean) call(name, types, args);
    }

    private String callString(String name, Class<?>[] types, Object... args) throws Exception {
        return (String) call(name, types, args);
    }

    private long callLong(String name, Class<?>[] types, Object... args) throws Exception {
        return (Long) call(name, types, args);
    }

    private double callDouble(String name, Class<?>[] types, Object... args) throws Exception {
        return (Double) call(name, types, args);
    }

    private Object call(String name, Class<?>[] types, Object... args) throws Exception {
        Method method = GreenhouseService.class.getDeclaredMethod(name, types);
        method.setAccessible(true);
        return method.invoke(service, args);
    }
}
