package com.morel.greenhouse.application.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.morel.greenhouse.application.dto.AiChatRequest;
import com.morel.greenhouse.application.dto.AiDiagnosisRequest;
import com.morel.greenhouse.domain.telemetry.TelemetrySnapshot;
import com.morel.greenhouse.infrastructure.ai.AiServiceClient;
import com.morel.greenhouse.shared.exception.BusinessException;
import com.morel.greenhouse.shared.security.CurrentUser;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class AiAssistantService {
    private final AiServiceClient aiServiceClient;
    private final GreenhouseQueryService greenhouseQueryService;
    private final UserAccountService userAccountService;
    private final JdbcTemplate jdbcTemplate;
    private final ObjectMapper objectMapper;

    public AiAssistantService(
            AiServiceClient aiServiceClient,
            GreenhouseQueryService greenhouseQueryService,
            UserAccountService userAccountService,
            JdbcTemplate jdbcTemplate,
            ObjectMapper objectMapper
    ) {
        this.aiServiceClient = aiServiceClient;
        this.greenhouseQueryService = greenhouseQueryService;
        this.userAccountService = userAccountService;
        this.jdbcTemplate = jdbcTemplate;
        this.objectMapper = objectMapper;
    }

    @Transactional
    public Map<String, Object> chat(AiChatRequest request, CurrentUser currentUser) {
        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("question", request.question());
        payload.put("greenhouse_id", request.greenhouseId());
        payload.put("environment", environment(request.greenhouseId(), currentUser));
        Map<String, Object> result = aiServiceClient.chat(payload);
        Long conversationId = createConversation(currentUser.id(), request.greenhouseId(), "CHAT", title(request.question()));
        saveMessage(conversationId, "USER", request.question(), null, null);
        saveMessage(conversationId, "AI", stringValue(result.get("answer")), null, result);
        result.put("conversationId", conversationId);
        return result;
    }

    @Transactional
    public Map<String, Object> diagnose(AiDiagnosisRequest request, CurrentUser currentUser) {
        String question = request.question() == null || request.question().isBlank()
                ? "请分析这张羊肚菌图片"
                : request.question().trim();
        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("question", question);
        payload.put("greenhouse_id", request.greenhouseId());
        payload.put("image_base64", stripDataUrl(request.imageBase64()));
        payload.put("image_filename", request.imageFilename() == null ? "" : request.imageFilename());
        payload.put("environment", environment(request.greenhouseId(), currentUser));
        Map<String, Object> result = aiServiceClient.visionDiagnosis(payload);
        Long conversationId = createConversation(currentUser.id(), request.greenhouseId(), "VISION", "图片诊断");
        saveMessage(conversationId, "USER", question, request.imageBase64(), null);
        saveMessage(conversationId, "AI", stringValue(result.get("answer")), null, result);
        maybeCreateSuggestion(currentUser, request.greenhouseId(), conversationId, result);
        result.put("conversationId", conversationId);
        return result;
    }

    public Map<String, Object> rebuildIndex(CurrentUser currentUser) {
        if (!currentUser.admin()) {
            throw new BusinessException(403, "只有管理员可以重建 AI 知识库索引");
        }
        return aiServiceClient.rebuildIndex();
    }

    public List<Map<String, Object>> suggestions(CurrentUser currentUser) {
        if (!currentUser.admin()) {
            throw new BusinessException(403, "只有管理员可以查看 AI 建议");
        }
        return jdbcTemplate.queryForList("""
                SELECT s.*, u.username AS farmer_username, g.name AS greenhouse_name
                FROM ai_suggestion s
                LEFT JOIN app_user u ON u.id = s.farmer_user_id
                LEFT JOIN greenhouse g ON g.id = s.greenhouse_id
                WHERE s.deleted = FALSE
                ORDER BY s.created_at DESC
                """);
    }

    @Transactional
    public void downlinkSuggestion(Long suggestionId, String note, CurrentUser currentUser) {
        if (!currentUser.admin()) {
            throw new BusinessException(403, "只有管理员可以下发 AI 建议");
        }
        Map<String, Object> suggestion = jdbcTemplate.queryForList("""
                SELECT *
                FROM ai_suggestion
                WHERE id = ? AND deleted = FALSE
                """, suggestionId).stream().findFirst().orElseThrow(() -> new BusinessException(404, "AI 建议不存在"));
        Long farmerId = longValue(suggestion.get("farmer_user_id"));
        if (farmerId == null) {
            throw new BusinessException(400, "该 AI 建议没有绑定农户，无法下发");
        }
        String content = "【AI生成建议】" + suggestion.get("title") + "\n" + suggestion.get("content")
                + (note == null || note.isBlank() ? "" : "\n管理员补充：" + note.trim());
        userAccountService.sendSystemMessage(farmerId, currentUser.id(), currentUser.id(), farmerId, content);
        jdbcTemplate.update("""
                UPDATE ai_suggestion
                SET status = 'DOWNLINKED', downlinked_by = ?, downlinked_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
                """, currentUser.id(), suggestionId);
    }

    private Map<String, Object> environment(Long greenhouseId, CurrentUser currentUser) {
        if (greenhouseId == null) {
            return Map.of();
        }
        TelemetrySnapshot telemetry = greenhouseQueryService.getTelemetry(greenhouseId, currentUser);
        String greenhouseName = jdbcTemplate.queryForObject("SELECT name FROM greenhouse WHERE id = ?", String.class, greenhouseId);
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("greenhouse_id", telemetry.greenhouseId());
        data.put("greenhouse_name", greenhouseName);
        data.put("air_temperature", telemetry.airTemperature());
        data.put("air_humidity", telemetry.airHumidity());
        data.put("soil_temperature", telemetry.soilTemperature());
        data.put("soil_humidity", telemetry.soilHumidity());
        data.put("ph_value", telemetry.phValue());
        data.put("co2_ppm", telemetry.co2Ppm());
        data.put("light_lux", telemetry.lightLux());
        return data;
    }

    private Long createConversation(Long userId, Long greenhouseId, String type, String title) {
        jdbcTemplate.update("""
                INSERT INTO ai_conversation(user_id, greenhouse_id, conversation_type, title)
                VALUES (?, ?, ?, ?)
                """, userId, greenhouseId, type, title);
        return jdbcTemplate.queryForObject("""
                SELECT id FROM ai_conversation
                WHERE user_id = ?
                ORDER BY id DESC
                LIMIT 1
                """, Long.class, userId);
    }

    private void saveMessage(Long conversationId, String senderType, String content, String imageUrl, Map<String, Object> result) {
        jdbcTemplate.update("""
                INSERT INTO ai_message(conversation_id, sender_type, content, image_url, risk_level, diagnosis, references_json, expert_trace_json)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """,
                conversationId,
                senderType,
                content,
                imageUrl,
                result == null ? null : stringValue(result.get("risk_level")),
                result == null ? null : stringValue(result.get("diagnosis")),
                result == null ? null : toJson(result.get("references")),
                result == null ? null : toJson(result.get("expert_trace"))
        );
    }

    private void maybeCreateSuggestion(CurrentUser currentUser, Long greenhouseId, Long conversationId, Map<String, Object> result) {
        String riskLevel = stringValue(result.get("risk_level"));
        if (!"HIGH".equalsIgnoreCase(riskLevel) && !"MEDIUM".equalsIgnoreCase(riskLevel)) {
            return;
        }
        Long farmerId = currentUser.admin() ? ownerOfGreenhouse(greenhouseId) : currentUser.id();
        jdbcTemplate.update("""
                INSERT INTO ai_suggestion(farmer_user_id, greenhouse_id, conversation_id, title, content, risk_level)
                VALUES (?, ?, ?, ?, ?, ?)
                """, farmerId, greenhouseId, conversationId, "羊肚菌图片风险诊断", stringValue(result.get("answer")), riskLevel.toUpperCase());
    }

    private Long ownerOfGreenhouse(Long greenhouseId) {
        if (greenhouseId == null) {
            return null;
        }
        List<Long> rows = jdbcTemplate.queryForList("SELECT owner_user_id FROM greenhouse WHERE id = ?", Long.class, greenhouseId);
        return rows.isEmpty() ? null : rows.get(0);
    }

    private String stripDataUrl(String imageBase64) {
        int comma = imageBase64.indexOf(',');
        return comma >= 0 ? imageBase64.substring(comma + 1) : imageBase64;
    }

    private String title(String value) {
        String text = value == null || value.isBlank() ? "AI 会话" : value.trim();
        return text.length() > 48 ? text.substring(0, 48) : text;
    }

    private Long longValue(Object value) {
        return value == null ? null : Long.valueOf(String.valueOf(value));
    }

    private String stringValue(Object value) {
        return value == null ? "" : String.valueOf(value);
    }

    private String toJson(Object value) {
        try {
            return value == null ? null : objectMapper.writeValueAsString(value);
        } catch (JsonProcessingException ex) {
            return null;
        }
    }
}
