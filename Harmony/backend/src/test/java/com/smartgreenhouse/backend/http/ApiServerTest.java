package com.smartgreenhouse.backend.http;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.lang.reflect.Method;
import java.net.URI;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class ApiServerTest {
    @Test
    void queryAndIntParamsShouldParseUriValues() throws Exception {
        HttpExchange exchange = mock(HttpExchange.class);
        when(exchange.getRequestURI()).thenReturn(new URI("http://localhost/sensor/history?greenhouseId=A01&limit=12"));

        assertEquals("A01", callString("queryParam", exchange, "greenhouseId"));
        assertEquals("", callString("queryParam", exchange, "missing"));
        assertEquals(12, callInt("intParam", exchange, "limit", 24));
        assertEquals(24, callInt("intParam", exchange, "missing", 24));
    }

    @Test
    void handleCorsShouldReturnTrueForOptionsAndFalseForGet() throws Exception {
        HttpExchange options = exchange("OPTIONS", "", "");
        assertTrue(callBoolean("handleCors", options));
        verify(options).sendResponseHeaders(204, -1);

        HttpExchange get = exchange("GET", "", "");
        assertFalse(callBoolean("handleCors", get));
    }

    @Test
    void readAndSendShouldUseUtf8JsonBody() throws Exception {
        HttpExchange input = exchange("POST", "", "{\"name\":\"A01\"}");
        assertEquals("{\"name\":\"A01\"}", callString("read", input));

        ByteArrayOutputStream output = new ByteArrayOutputStream();
        HttpExchange response = exchange("GET", output, "");
        callVoid("send", response, 200, "{\"success\":true}");
        assertEquals("{\"success\":true}", output.toString("UTF-8"));
        verify(response).sendResponseHeaders(200, "{\"success\":true}".getBytes("UTF-8").length);
    }

    private HttpExchange exchange(String method, String query, String body) throws Exception {
        return exchange(method, new ByteArrayOutputStream(), body, query);
    }

    private HttpExchange exchange(String method, ByteArrayOutputStream output, String body) throws Exception {
        return exchange(method, output, body, "");
    }

    private HttpExchange exchange(String method, ByteArrayOutputStream output, String body, String query) throws Exception {
        HttpExchange exchange = mock(HttpExchange.class);
        when(exchange.getRequestMethod()).thenReturn(method);
        when(exchange.getRequestHeaders()).thenReturn(new Headers());
        when(exchange.getResponseHeaders()).thenReturn(new Headers());
        when(exchange.getRequestBody()).thenReturn(new ByteArrayInputStream(body.getBytes("UTF-8")));
        when(exchange.getResponseBody()).thenReturn(output);
        when(exchange.getRequestURI()).thenReturn(new URI("http://localhost/test" + (query.isEmpty() ? "" : "?" + query)));
        return exchange;
    }

    private String callString(String name, HttpExchange exchange, Object... extra) throws Exception {
        Object[] args = new Object[extra.length + 1];
        args[0] = exchange;
        System.arraycopy(extra, 0, args, 1, extra.length);
        Class<?>[] types = new Class<?>[args.length];
        types[0] = HttpExchange.class;
        for (int i = 1; i < types.length; i++) {
            types[i] = String.class;
        }
        Method method = ApiServer.class.getDeclaredMethod(name, types);
        method.setAccessible(true);
        return (String) method.invoke(server(), args);
    }

    private int callInt(String name, HttpExchange exchange, String key, int fallback) throws Exception {
        Method method = ApiServer.class.getDeclaredMethod(name, HttpExchange.class, String.class, int.class);
        method.setAccessible(true);
        return (Integer) method.invoke(server(), exchange, key, fallback);
    }

    private boolean callBoolean(String name, HttpExchange exchange) throws Exception {
        Method method = ApiServer.class.getDeclaredMethod(name, HttpExchange.class);
        method.setAccessible(true);
        return (Boolean) method.invoke(server(), exchange);
    }

    private void callVoid(String name, HttpExchange exchange, int status, String body) throws Exception {
        Method method = ApiServer.class.getDeclaredMethod(name, HttpExchange.class, int.class, String.class);
        method.setAccessible(true);
        method.invoke(server(), exchange, status, body);
    }

    private ApiServer server() throws Exception {
        return new ApiServer(0);
    }
}
