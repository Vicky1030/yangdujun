package com.morel.greenhouse.interfaces.controller;

import com.morel.greenhouse.application.dto.FeedbackRequest;
import com.morel.greenhouse.application.dto.ProfileUpdateRequest;
import com.morel.greenhouse.application.service.UserAccountService;
import com.morel.greenhouse.shared.api.ApiResult;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/users")
public class UserController {
    private final UserAccountService userAccountService;

    public UserController(UserAccountService userAccountService) {
        this.userAccountService = userAccountService;
    }

    @GetMapping("/{id}/profile")
    public ApiResult<Map<String, Object>> profile(@PathVariable Long id, HttpServletRequest request) {
        Map<String, Object> profile = userAccountService.profile(id);
        profile.put("realtimeIp", clientIp(request));
        return ApiResult.ok(profile);
    }

    @PutMapping("/{id}/profile")
    public ApiResult<Map<String, Object>> updateProfile(@PathVariable Long id, @RequestBody ProfileUpdateRequest request) {
        return ApiResult.ok(userAccountService.updateProfile(id, request));
    }

    @PostMapping("/feedback")
    public ApiResult<Void> feedback(@Valid @RequestBody FeedbackRequest request) {
        userAccountService.feedback(request);
        return ApiResult.ok();
    }

    @GetMapping
    public ApiResult<List<Map<String, Object>>> users() {
        return ApiResult.ok(userAccountService.users());
    }

    @GetMapping("/feedback")
    public ApiResult<List<Map<String, Object>>> feedbacks() {
        return ApiResult.ok(userAccountService.feedbacks());
    }

    @GetMapping("/operation-logs")
    public ApiResult<Map<String, Object>> operationLogs(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String module,
            @RequestParam(required = false) String username,
            @RequestParam(required = false) Boolean success,
            @RequestParam(required = false) String startTime,
            @RequestParam(required = false) String endTime
    ) {
        return ApiResult.ok(userAccountService.operationLogs(page, size, keyword, module, username, success, startTime, endTime));
    }

    private String clientIp(HttpServletRequest request) {
        String forwarded = request.getHeader("X-Forwarded-For");
        if (forwarded != null && !forwarded.isBlank()) {
            return forwarded.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}
