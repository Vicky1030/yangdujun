package com.morel.greenhouse.infrastructure.ai;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.morel.greenhouse.shared.exception.BusinessException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Map;

@Component
public class AiServiceClient {
    private static final Logger log = LoggerFactory.getLogger(AiServiceClient.class);
    private static final TypeReference<Map<String, Object>> MAP_TYPE = new TypeReference<>() {
    };

    private final String serviceUrl;
    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;

    public AiServiceClient(@Value("${greenhouse.ai.service-url}") String serviceUrl, ObjectMapper objectMapper) {
        this.serviceUrl = serviceUrl.endsWith("/") ? serviceUrl.substring(0, serviceUrl.length() - 1) : serviceUrl;
        this.objectMapper = objectMapper;
        this.httpClient = HttpClient.newBuilder()
                .version(HttpClient.Version.HTTP_1_1)
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }

    public Map<String, Object> chat(Map<String, Object> payload) {
        return post("/api/chat", payload);
    }

    public Map<String, Object> visionDiagnosis(Map<String, Object> payload) {
        return post("/api/vision-diagnosis", payload);
    }

    public Map<String, Object> rebuildIndex() {
        return post("/api/index/rebuild", Map.of());
    }

    private Map<String, Object> post(String path, Map<String, Object> payload) {
        try {
            String json = objectMapper.writeValueAsString(payload);
            log.debug("Sending local AI request, path={}, bodyLength={}", path, json.length());
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(serviceUrl + path))
                    .timeout(Duration.ofMinutes(5))
                    .header("Content-Type", "application/json; charset=utf-8")
                    .header("Accept", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(json, StandardCharsets.UTF_8))
                    .build();
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            if (response.statusCode() < 200 || response.statusCode() >= 300) {
                log.warn("Local AI service returned error, path={}, status={}, body={}", path, response.statusCode(), response.body());
                throw new BusinessException(502, "本地 AI 服务返回异常，请查看 ai-service 日志");
            }
            return objectMapper.readValue(response.body(), MAP_TYPE);
        } catch (BusinessException ex) {
            throw ex;
        } catch (IOException ex) {
            log.warn("Local AI service JSON or IO error, path={}", path, ex);
            throw new BusinessException(502, "本地 AI 服务数据解析失败，请确认 AI 服务响应格式");
        } catch (InterruptedException ex) {
            Thread.currentThread().interrupt();
            log.warn("Local AI service request interrupted, path={}", path, ex);
            throw new BusinessException(502, "本地 AI 服务请求被中断，请稍后重试");
        } catch (RuntimeException ex) {
            log.warn("Local AI service request failed, path={}", path, ex);
            throw new BusinessException(502, "本地 AI 服务暂不可用，请确认 ai-service 和 Ollama 已启动");
        }
    }
}
