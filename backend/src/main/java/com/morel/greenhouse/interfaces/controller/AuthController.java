package com.morel.greenhouse.interfaces.controller;

import com.morel.greenhouse.application.dto.LoginRequest;
import com.morel.greenhouse.application.dto.PhoneLoginRequest;
import com.morel.greenhouse.application.dto.RegisterRequest;
import com.morel.greenhouse.application.dto.ResetPasswordRequest;
import com.morel.greenhouse.application.dto.VerificationCodeRequest;
import com.morel.greenhouse.application.service.AuthService;
import com.morel.greenhouse.shared.api.ApiResult;
import com.morel.greenhouse.shared.exception.BusinessException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {
    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ApiResult<Map<String, Object>> login(@Valid @RequestBody LoginRequest request, HttpServletRequest servletRequest) {
        return ApiResult.ok(authService.login(request, clientIp(servletRequest)));
    }

    @PostMapping("/register")
    public ApiResult<Map<String, Object>> register(@Valid @RequestBody RegisterRequest request) {
        return ApiResult.ok(authService.register(request));
    }

    @PostMapping("/phone-login")
    public ApiResult<Map<String, Object>> phoneLogin(@Valid @RequestBody PhoneLoginRequest request, HttpServletRequest servletRequest) {
        return ApiResult.ok(authService.phoneLogin(request, clientIp(servletRequest)));
    }

    @PostMapping("/codes")
    public ApiResult<Map<String, String>> sendCode(@Valid @RequestBody VerificationCodeRequest request) {
        return ApiResult.ok(authService.sendCode(request));
    }

    @PostMapping("/password/reset")
    public ApiResult<Void> resetPassword(@Valid @RequestBody ResetPasswordRequest request) {
        authService.resetPassword(request);
        return ApiResult.ok();
    }

    @GetMapping("/policies/{type}")
    public ApiResult<Map<String, String>> policy(@PathVariable String type) {
        if (!"privacy".equals(type) && !"terms".equals(type)) {
            throw new BusinessException(404, "政策文档不存在");
        }
        String title = "privacy".equals(type) ? "隐私政策" : "服务条款";
        String content = "privacy".equals(type)
                ? """
                本系统仅为智慧农业生产管理采集必要数据，包括账号、联系方式、设备状态、环境数据、操作日志和问题反馈。
                数据用于身份认证、生产管理、安全审计、故障追踪和服务改进。未经授权不会用于无关用途。
                用户可以在个人中心维护手机号、邮箱、头像、简介、性别等资料，并可通过问题反馈功能联系管理员处理数据相关问题。
                """
                : """
                用户应保证账号信息真实有效，不得冒用管理员账号 admin，不得绕过设备安全策略或提交虚假生产数据。
                平台会记录关键操作日志，用于审计、排障和保护农业生产安全。
                当前硬件联动采用可扩展网关接口，真实设备接入后应遵守现场安全规范和管理员授权流程。
                """;
        return ApiResult.ok(Map.of("title", title, "content", content));
    }

    private String clientIp(HttpServletRequest request) {
        String forwarded = request.getHeader("X-Forwarded-For");
        if (forwarded != null && !forwarded.isBlank()) {
            return forwarded.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}
