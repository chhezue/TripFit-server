package com.tripfit.tripfit.user.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

@Schema(description = "성·이름 프로필 PATCH 요청")
public record UpdateProfileRequest(
    @Schema(
        description = "이름 (공백 불가)",
        example = "길동",
        requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank
    String firstName,

    @Schema(
        description = "성 (공백 불가)",
        example = "홍",
        requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank
    String lastName
) {
}
