package com.morel.greenhouse.application.service;

import com.morel.greenhouse.application.dto.LoginRequest;
import com.morel.greenhouse.application.dto.RegisterRequest;
import com.morel.greenhouse.application.dto.ResetPasswordRequest;
import com.morel.greenhouse.application.dto.VerificationCodeRequest;
import com.morel.greenhouse.shared.exception.BusinessException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class AuthService {
    private static final Logger log = LoggerFactory.getLogger(AuthService.class);
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final int SESSION_HOURS = 24;

    private final JdbcTemplate jdbcTemplate;
    private final PasswordEncoder passwordEncoder;
    private final VerificationDeliveryService deliveryService;

    public AuthService(
            JdbcTemplate jdbcTemplate,
            PasswordEncoder passwordEncoder,
            VerificationDeliveryService deliveryService
    ) {
        this.jdbcTemplate = jdbcTemplate;
        this.passwordEncoder = passwordEncoder;
        this.deliveryService = deliveryService;
    }

    public Map<String, Object> login(LoginRequest request, String clientIp) {
        if (request.username() == null || request.username().isBlank()) {
            throw new BusinessException(400, "用户名不能为空");
        }
        if (request.password() == null || request.password().isBlank()) {
            throw new BusinessException(400, "密码不能为空");
        }
        Map<String, Object> user = findUserByUsername(request.username());
        assertEnabled(user);
        String stored = stripPrefix((String) user.get("password_hash"));
        if (!passwordEncoder.matches(request.password(), stored)) {
            throw new BusinessException(401, "用户名或密码错误");
        }
        jdbcTemplate.update("UPDATE app_user SET last_login_ip = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?", clientIp, user.get("id"));
        log.info("User logged in: username={}, role={}, ip={}", user.get("username"), user.get("role_code"), clientIp);
        return authPayload(user, clientIp);
    }

    @Transactional
    public Map<String, Object> register(RegisterRequest request) {
        if ("admin".equalsIgnoreCase(request.username())) {
            throw new BusinessException(400, "admin 是系统保留用户名，不能注册或修改为 admin");
        }
        if (!request.password().equals(request.confirmPassword())) {
            throw new BusinessException(400, "两次输入的密码不一致");
        }
        verifyCode(request.email(), "REGISTER", request.verificationCode());
        Integer exists = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM app_user WHERE username = ? OR phone = ? OR email = ?",
                Integer.class,
                request.username(),
                request.phone(),
                request.email()
        );
        if (exists != null && exists > 0) {
            throw new BusinessException(409, "用户名、手机号或邮箱已存在");
        }
        jdbcTemplate.update("""
                INSERT INTO app_user(username, password_hash, role_code, phone, email, display_name, gender, bio)
                VALUES (?, ?, 'FARMER', ?, ?, ?, 'UNKNOWN', '')
                """,
                request.username(),
                "{bcrypt}" + passwordEncoder.encode(request.password()),
                request.phone(),
                request.email(),
                request.displayName() == null || request.displayName().isBlank() ? "" : request.displayName()
        );
        log.info("Farmer account registered: username={}, phone={}, email={}", request.username(), request.phone(), request.email());
        return authPayload(findUserByUsername(request.username()), "");
    }

    public Map<String, String> sendCode(VerificationCodeRequest request) {
        if (request.receiver() == null || request.receiver().isBlank()) {
            throw new BusinessException(400, "邮箱不能为空");
        }
        if (!request.receiver().contains("@")) {
            throw new BusinessException(400, "验证码只能发送到邮箱");
        }
        String code = String.valueOf(100000 + RANDOM.nextInt(900000));
        jdbcTemplate.update("""
                INSERT INTO verification_code(receiver, scene, code, expires_at)
                VALUES (?, ?, ?, ?)
                """, request.receiver(), request.scene(), code, LocalDateTime.now().plusMinutes(5));
        VerificationDeliveryService.DeliveryResult delivery = deliveryService.deliverEmail(request.receiver(), request.scene(), code);
        log.info("Email verification code generated: receiver={}, scene={}, deliveryMode={}",
                request.receiver(), request.scene(), delivery.devMode() ? "DEV" : "REAL");
        Map<String, String> result = new HashMap<>();
        result.put("message", delivery.message() + "，有效期 5 分钟");
        result.put("deliveryMode", delivery.devMode() ? "DEV" : "REAL");
        if (delivery.devMode()) {
            result.put("devCode", code);
        }
        return result;
    }

    @Transactional
    public void resetPassword(ResetPasswordRequest request) {
        if (!request.receiver().contains("@")) {
            throw new BusinessException(400, "请使用邮箱重置密码");
        }
        if (!request.newPassword().equals(request.confirmPassword())) {
            throw new BusinessException(400, "两次输入的密码不一致");
        }
        verifyCode(request.receiver(), "RESET_PASSWORD", request.verificationCode());
        int updated = jdbcTemplate.update("""
                UPDATE app_user SET password_hash = ?, updated_at = CURRENT_TIMESTAMP
                WHERE email = ?
                """, "{bcrypt}" + passwordEncoder.encode(request.newPassword()), request.receiver());
        if (updated == 0) {
            throw new BusinessException(404, "未找到绑定该邮箱的用户");
        }
        log.info("Password reset completed for email={}", request.receiver());
    }

    private void verifyCode(String receiver, String scene, String code) {
        if (receiver == null || receiver.isBlank() || code == null || code.isBlank()) {
            throw new BusinessException(400, "验证码不能为空");
        }
        List<Map<String, Object>> rows = jdbcTemplate.queryForList("""
                SELECT id FROM verification_code
                WHERE receiver = ? AND scene = ? AND code = ? AND used = FALSE AND expires_at > CURRENT_TIMESTAMP
                ORDER BY created_at DESC LIMIT 1
                """, receiver, scene, code);
        if (rows.isEmpty()) {
            throw new BusinessException(400, "验证码无效或已过期");
        }
        jdbcTemplate.update("UPDATE verification_code SET used = TRUE WHERE id = ?", rows.get(0).get("id"));
    }

    private Map<String, Object> findUserByUsername(String username) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList("SELECT * FROM app_user WHERE username = ?", username);
        return rows.stream().findFirst().orElseThrow(() -> new BusinessException(401, "用户名或密码错误"));
    }

    private Map<String, Object> authPayload(Map<String, Object> user, String clientIp) {
        String token = UUID.randomUUID().toString();
        jdbcTemplate.update("""
                INSERT INTO app_session(token, user_id, username, role_code, client_ip, expires_at)
                VALUES (?, ?, ?, ?, ?, ?)
                """,
                token,
                user.get("id"),
                user.get("username"),
                user.get("role_code"),
                clientIp,
                LocalDateTime.now().plusHours(SESSION_HOURS)
        );
        return Map.of(
                "token", token,
                "profile", Map.of(
                        "id", user.get("id"),
                        "username", user.get("username"),
                        "displayName", value(user.get("display_name")),
                        "phone", value(user.get("phone")),
                        "email", value(user.get("email")),
                        "role", user.get("role_code"),
                        "avatarUrl", value(user.get("avatar_url")),
                        "gender", value(user.get("gender")),
                        "bio", value(user.get("bio")),
                        "lastLoginIp", value(user.get("last_login_ip"))
                )
        );
    }

    private void assertEnabled(Map<String, Object> user) {
        Object enabled = user.get("enabled");
        if (enabled instanceof Boolean bool && !bool) {
            throw new BusinessException(403, "账号已被禁用");
        }
    }

    private String stripPrefix(String passwordHash) {
        return passwordHash == null ? "" : passwordHash.replace("{bcrypt}", "");
    }

    private String value(Object value) {
        return value == null ? "" : String.valueOf(value);
    }
}
