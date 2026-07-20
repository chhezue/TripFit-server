package com.tripfit.tripfit.user.service;

import com.tripfit.tripfit.auth.exception.AuthErrorCode;
import com.tripfit.tripfit.common.exception.TripFitException;
import com.tripfit.tripfit.user.domain.User;
import com.tripfit.tripfit.user.dto.UpdateMyPageRequest;
import com.tripfit.tripfit.user.dto.UpdateProfileRequest;
import com.tripfit.tripfit.user.dto.UserSummaryResponse;
import com.tripfit.tripfit.user.exception.UserErrorCode;
import com.tripfit.tripfit.user.repository.UserRepository;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
// 성·이름 PATCH 및 trip 핵심 API 진입 전 이름 완료 검증 — UserSummary는 UserSummaryService에 위임
public class UserProfileService {

  private final UserRepository userRepository;

  private final UserSummaryService userSummaryService;

  public UserProfileService(UserRepository userRepository, UserSummaryService userSummaryService) {
    this.userRepository = userRepository;
    this.userSummaryService = userSummaryService;
  }

  @Transactional
  public UserSummaryResponse updateProfile(UUID userId, UpdateProfileRequest request) {
    User user = findUser(userId);
    user.setFirstName(request.firstName().trim());
    user.setLastName(request.lastName().trim());
    // hasPreSchedule은 userSummaryService가 일정 테이블 EXISTS로 매번 파생
    return userSummaryService.toSummary(user);
  }

  @Transactional
  public UserSummaryResponse updateMyPage(UUID userId, UpdateMyPageRequest request) {
    return updateProfile(userId, new UpdateProfileRequest(request.firstName(), request.lastName()));
  }

  // BR-USER-001 · D-NAME-1: trip 생성·join 등 핵심 API — first/last null이면 403 PROFILE_NAME_REQUIRED
  public void requireProfileNameComplete(User user) {
    if (!user.hasProfileNameComplete()) {
      throw new TripFitException(UserErrorCode.PROFILE_NAME_REQUIRED);
    }
  }

  private User findUser(UUID userId) {
    return userRepository
        .findById(userId)
        .orElseThrow(() -> new TripFitException(AuthErrorCode.AUTH_FORBIDDEN));
  }
}
