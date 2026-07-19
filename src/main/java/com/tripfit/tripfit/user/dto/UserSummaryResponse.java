package com.tripfit.tripfit.user.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.tripfit.tripfit.user.domain.SocialProvider;
import io.swagger.v3.oas.annotations.media.Schema;
import java.util.UUID;

@JsonInclude(JsonInclude.Include.NON_NULL)
@Schema(
    description = "사용자 요약 (login · GET /auth/me · PATCH /users/profile · PATCH /users/my-page 공통)")
public record UserSummaryResponse(
    @Schema(description = "TripFit 사용자 ID (UUID v4)",
        example = "550e8400-e29b-41d4-a716-446655440000") UUID id,

    @Schema(
        description = "소셜 계정 이메일. 미제공 시 null",
        nullable = true,
        example = "user@example.com") String email,

    @Schema(
        description = "유저 입력 이름. 미입력 시 null",
        nullable = true,
        example = "길동") String firstName,

    @Schema(
        description = "유저 입력 성. 미입력 시 null",
        nullable = true,
        example = "홍") String lastName,

    @Schema(
        description = "소셜 provider 표시명 (prefill용). 미제공 시 null",
        nullable = true,
        example = "홍길동") String nickname,

    @Schema(
        description = "프로필 이미지 URL. wave 1: provider CDN URL. wave 4: TripFit S3 URL 예정",
        nullable = true,
        example = "https://lh3.googleusercontent.com/a/example") String profileImageUrl,

    @Schema(description = "로그인에 사용한 소셜 제공자") SocialProvider provider,

    @Schema(
        description = "Google Calendar OAuth 연동 여부. user.is_google_calendar_connected 컬럼 SSOT",
        example = "false") boolean isGoogleCalendarConnected,

    @Schema(
        description = """
            사전 일정 존재 여부 (파생·DB 컬럼 없음). SSOT: regular_schedule OR personal_schedule row ≥1.
            조회 시마다 계산(login/me/profile). true 전환: POST regular 첫 생성 또는 PATCH personal 첫 저장.
            false 전환: 해당 kind row 전부 삭제 후 둘 다 0건. 일정 CRUD 응답에는 미포함 — 갱신값은 GET /auth/me 등 재호출.
            """,
        example = "false") boolean hasPreSchedule,

    @Schema(
        description = """
            전부 free 선언 (user.is_all_free). default false=미입력.
            방 입장: hasPreSchedule OR isAllFree. Skip+0행 시 create/join에서 true.
            docs/specs/schedule-participation-onboarding.md D-JOIN-ENTRY
            """,
        example = "false") boolean isAllFree
) {
}
