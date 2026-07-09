package com.tripfit.tripfit.user.service;

import com.tripfit.tripfit.user.domain.User;
import com.tripfit.tripfit.user.dto.UserSummaryResponse;

public final class UserSummaryMapper {

  private UserSummaryMapper() {}

  // User 엔티티를 login·me·PATCH 응답용 요약 DTO로 변환함
  public static UserSummaryResponse toSummary(User user) {
    return new UserSummaryResponse(
        user.getId(),
        user.getEmail(),
        user.getFirstName(),
        user.getLastName(),
        user.getNickname(),
        user.getProfileImageUrl(),
        user.getProvider(),
        user.isGoogleCalendarConnected(),
        user.isScheduleRegistered(),
        user.isOptionalOnboardingCompleted());
  }
}
