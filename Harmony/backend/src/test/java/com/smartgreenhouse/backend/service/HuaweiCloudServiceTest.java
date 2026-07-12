package com.smartgreenhouse.backend.service;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Field;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class HuaweiCloudServiceTest {
    private final HuaweiCloudService service = new HuaweiCloudService();

    @Test
    void privateShadowParserShouldMapSensorValues() throws Exception {
        String body = "{"
                + "\"Temp\":18.5,\"Humi\":85,\"Soil_Temp\":17,\"Soil_Humi\":70,"
                + "\"Lumi\":1200,\"CO2\":680,\"O2\":20.8,\"pH\":6.8,"
                + "\"Dist\":30,\"Fengd\":3,\"LightSt\":\"ON\",\"Bump\":\"true\","
                + "\"AIWarning\":\"normal\",\"GrowthStage\":4,\"event_time\":\"now\""
                + "}";

        String result = callString("sensorJsonFromShadow", new Class<?>[]{String.class}, body);
        assertTrue(result.contains("\"airTemperature\":18.5"));
        assertTrue(result.contains("\"waterPumpOn\":true"));
        assertTrue(result.contains("\"growthStage\":4"));
    }

    @Test
    void commandShouldNormalizeKnownDeviceCommands() throws Exception {
        Object fan = call("command", new Class<?>[]{String.class, String.class}, "Fengdegree", "20");
        assertEquals("Fengd", field(fan, "name"));
        assertEquals("Fengd", field(fan, "param"));
        assertEquals("9", field(fan, "jsonValue"));

        Object light = call("command", new Class<?>[]{String.class, String.class}, "Light", "ON");
        assertEquals("LightSt", field(light, "name"));
        assertEquals("LightSt", field(light, "param"));
        assertEquals("\"ON\"", field(light, "jsonValue"));
    }

    @Test
    void jsonExtractionHelpersShouldFallbackSafely() throws Exception {
        assertEquals(12.5, callDouble("firstNumber", new Class<?>[]{String.class, double.class, String[].class},
                "{\"value\":12.5}", -1.0, new String[]{"value"}));
        assertEquals(-1.0, callDouble("firstNumber", new Class<?>[]{String.class, double.class, String[].class},
                "{}", -1.0, new String[]{"missing"}));
        assertEquals(true, callBoolean("bool", new Class<?>[]{String.class, String[].class},
                "{\"flag\":\"ON\"}", new String[]{"flag"}));
        assertEquals("abc", callString("firstText", new Class<?>[]{String.class, String.class, String[].class},
                "{\"name\":\"abc\"}", "", new String[]{"name"}));
    }

    @Test
    void commandTimeoutTextShouldBeRecognizedAsPendingCommand() throws Exception {
        assertEquals(true, callBoolean("isCommandTimeout", new Class<?>[]{String.class},
                "Command timeout. No response was received from the device within the specified time."));
        assertEquals(false, callBoolean("isCommandTimeout", new Class<?>[]{String.class}, "invalid command"));
    }

    @Test
    void privateResultObjectsShouldExposeHeadersAndFields() throws Exception {
        Class<?> tokenType = Class.forName("com.smartgreenhouse.backend.service.HuaweiCloudService$Token");
        Constructor<?> tokenConstructor = tokenType.getDeclaredConstructor(String.class, long.class);
        tokenConstructor.setAccessible(true);
        Object token = tokenConstructor.newInstance("token-value", 123L);
        assertEquals("token-value", field(token, "value"));
        assertEquals(123L, field(token, "expireAtMs"));

        Class<?> resultType = Class.forName("com.smartgreenhouse.backend.service.HuaweiCloudService$HttpResult");
        Constructor<?> resultConstructor = resultType.getDeclaredConstructor(int.class, String.class, String.class);
        resultConstructor.setAccessible(true);
        Object result = resultConstructor.newInstance(200, null, "subject-token");
        Method header = resultType.getDeclaredMethod("header", String.class);
        header.setAccessible(true);
        assertEquals("subject-token", header.invoke(result, "X-Subject-Token"));
        assertEquals("", header.invoke(result, "Other"));
        assertEquals("", field(result, "body"));
    }

    private Object call(String name, Class<?>[] types, Object... args) throws Exception {
        Method method = HuaweiCloudService.class.getDeclaredMethod(name, types);
        method.setAccessible(true);
        return method.invoke(service, args);
    }

    private String callString(String name, Class<?>[] types, Object... args) throws Exception {
        return (String) call(name, types, args);
    }

    private double callDouble(String name, Class<?>[] types, Object... args) throws Exception {
        return (Double) call(name, types, args);
    }

    private boolean callBoolean(String name, Class<?>[] types, Object... args) throws Exception {
        return (Boolean) call(name, types, args);
    }

    private Object field(Object target, String name) throws Exception {
        Field field = target.getClass().getDeclaredField(name);
        field.setAccessible(true);
        return field.get(target);
    }
}
