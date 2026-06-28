package com.morel.greenhouse.application.service;

import com.morel.greenhouse.application.dto.FeedbackRequest;
import com.morel.greenhouse.application.dto.ProfileUpdateRequest;
import com.morel.greenhouse.shared.exception.BusinessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class UserAccountService {
    private final JdbcTemplate jdbcTemplate;

    public UserAccountService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Map<String, Object> profile(Long userId) {
        return jdbcTemplate.queryForList("""
                SELECT id, username, role_code, phone, email, display_name, avatar_url, gender, bio, last_login_ip
                FROM app_user WHERE id = ?
                """, userId).stream().findFirst().orElseThrow(() -> new BusinessException(404, "用户不存在"));
    }

    @Transactional
    public Map<String, Object> updateProfile(Long userId, ProfileUpdateRequest request) {
        Map<String, Object> current = profile(userId);
        String nextUsername = blankToDefault(request.username(), String.valueOf(current.get("username")));
        if ("admin".equalsIgnoreCase(nextUsername) && !"admin".equalsIgnoreCase(String.valueOf(current.get("username")))) {
            throw new BusinessException(400, "普通用户不能修改用户名为 admin");
        }
        jdbcTemplate.update("""
                UPDATE app_user SET username = ?, phone = ?, email = ?, display_name = ?, avatar_url = ?, gender = ?, bio = ?, updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
                """,
                nextUsername,
                blankToDefault(request.phone(), stringValue(current.get("phone"))),
                blankToDefault(request.email(), stringValue(current.get("email"))),
                blankToDefault(request.displayName(), stringValue(current.get("display_name"))),
                blankToDefault(request.avatarUrl(), stringValue(current.get("avatar_url"))),
                blankToDefault(request.gender(), stringValue(current.get("gender"))),
                blankToDefault(request.bio(), stringValue(current.get("bio"))),
                userId
        );
        return profile(userId);
    }

    public void feedback(FeedbackRequest request) {
        jdbcTemplate.update("""
                INSERT INTO feedback(user_id, category, content, contact)
                VALUES (?, ?, ?, ?)
                """, request.userId(), request.category(), request.content(), request.contact());
    }

    public List<Map<String, Object>> feedbacks() {
        return jdbcTemplate.queryForList("SELECT * FROM feedback ORDER BY created_at DESC");
    }

    public List<Map<String, Object>> users() {
        return jdbcTemplate.queryForList("""
                SELECT id, username, role_code, phone, email, display_name, gender, enabled, created_at, last_login_ip
                FROM app_user ORDER BY created_at DESC
                """);
    }

    public Map<String, Object> operationLogs(int page, int size) {
        int normalizedPage = Math.max(page, 1);
        int normalizedSize = Math.min(Math.max(size, 1), 100);
        int offset = (normalizedPage - 1) * normalizedSize;
        Long total = jdbcTemplate.queryForObject("SELECT COUNT(1) FROM operation_log", Long.class);
        List<Map<String, Object>> records = jdbcTemplate.queryForList("""
                SELECT *
                FROM operation_log
                ORDER BY created_at DESC
                LIMIT ? OFFSET ?
                """, normalizedSize, offset);
        long totalValue = total == null ? 0L : total;
        long pages = totalValue == 0 ? 0 : (totalValue + normalizedSize - 1) / normalizedSize;
        return Map.of(
                "records", records,
                "total", totalValue,
                "page", normalizedPage,
                "size", normalizedSize,
                "pages", pages
        );
    }

    private String blankToDefault(String value, String fallback) {
        return value == null || value.isBlank() ? fallback : value;
    }

    private String stringValue(Object value) {
        return value == null ? "" : String.valueOf(value);
    }
}
