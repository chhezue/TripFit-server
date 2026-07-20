package com.tripfit.tripfit.user.controller;

import com.tripfit.tripfit.auth.jwt.AuthorizedUser;
import com.tripfit.tripfit.common.api.ApiResponse;
import com.tripfit.tripfit.user.dto.UpdateMyPageRequest;
import com.tripfit.tripfit.user.dto.UpdateProfileRequest;
import com.tripfit.tripfit.user.dto.UserSummaryResponse;
import com.tripfit.tripfit.user.service.UserProfileService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.UUID;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "User")
@RestController
@RequestMapping("/api/v1/users")
public class UserController {

  private final UserProfileService userProfileService;

  public UserController(UserProfileService userProfileService) {
    this.userProfileService = userProfileService;
  }

  @Operation(
      summary = "프로필(성·이름) 저장",
      description = "성·이름 필수. 응답 user.hasPreSchedule은 일정 row EXISTS 파생(저장 필드 아님). 미완료 시 trip 생성·join 403")
  @PatchMapping("/profile")
  ResponseEntity<ApiResponse<UserSummaryResponse>> updateProfile(
      @AuthorizedUser UUID userId,
      @Valid @RequestBody UpdateProfileRequest request) {
    UserSummaryResponse response = userProfileService.updateProfile(userId, request);
    return ResponseEntity.ok(ApiResponse.of(response));
  }

  @Operation(
      summary = "마이페이지 이름 수정",
      description = "성·이름만 수정. 응답 user.hasPreSchedule은 login/me와 동일하게 조회 시 파생")
  @PatchMapping("/my-page")
  ResponseEntity<ApiResponse<UserSummaryResponse>> updateMyPage(
      @AuthorizedUser UUID userId,
      @Valid @RequestBody UpdateMyPageRequest request) {
    UserSummaryResponse response = userProfileService.updateMyPage(userId, request);
    return ResponseEntity.ok(ApiResponse.of(response));
  }
}
