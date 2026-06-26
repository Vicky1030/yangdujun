package com.morel.greenhouse.application.dto;

import jakarta.validation.constraints.NotBlank;

public record PhoneLoginRequest(
        @NotBlank String phone,
        @NotBlank String verificationCode,
        @NotBlank String captchaToken
) {
}
