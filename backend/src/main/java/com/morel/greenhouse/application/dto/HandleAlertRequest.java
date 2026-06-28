package com.morel.greenhouse.application.dto;

import jakarta.validation.constraints.NotBlank;

public record HandleAlertRequest(
        @NotBlank String status,
        @NotBlank String handler,
        String note
) {
}
