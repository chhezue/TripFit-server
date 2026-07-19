package com.tripfit.tripfit.user.service;

import com.tripfit.tripfit.auth.exception.AuthErrorCode;
import com.tripfit.tripfit.common.exception.TripFitException;
import com.tripfit.tripfit.user.domain.User;
import com.tripfit.tripfit.user.dto.UserSummaryResponse;
import com.tripfit.tripfit.user.exception.UserErrorCode;
import com.tripfit.tripfit.user.repository.UserRepository;
import com.tripfit.tripfit.user.schedule.repository.PersonalScheduleRepository;
import com.tripfit.tripfit.user.schedule.repository.RegularScheduleRepository;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

// login · GET /auth/me · PATCH profile 응답용 UserSummary + 방 입장 게이트(D-JOIN-ENTRY)
@Service
public class UserSummaryService {

  private final RegularScheduleRepository regularScheduleRepository;

  private final PersonalScheduleRepository personalScheduleRepository;

  private final UserRepository userRepository;

  public UserSummaryService(
      RegularScheduleRepository regularScheduleRepository,
      PersonalScheduleRepository personalScheduleRepository,
      UserRepository userRepository) {
    this.regularScheduleRepository = regularScheduleRepository;
    this.personalScheduleRepository = personalScheduleRepository;
    this.userRepository = userRepository;
  }

  @Transactional(readOnly = true)
  public UserSummaryResponse toSummary(User user) {
    return new UserSummaryResponse(
        user.getId(),
        user.getEmail(),
        user.getFirstName(),
        user.getLastName(),
        user.getNickname(),
        user.getProfileImageUrl(),
        user.getProvider(),
        user.isGoogleCalendarConnected(),
        hasPreSchedule(user.getId()),
        user.isAllFree());
  }

  // 파생: regular OR personal row EXISTS (user 컬럼 아님)
  @Transactional(readOnly = true)
  public boolean hasPreSchedule(UUID userId) {
    return regularScheduleRepository.existsByUserId(userId)
        || personalScheduleRepository.existsByUserId(userId);
  }

  // D-JOIN-ENTRY: 정기≥1 OR 개별≥1 OR is_all_free
  @Transactional(readOnly = true)
  public boolean canEnterRoom(User user) {
    return user.isAllFree() || hasPreSchedule(user.getId());
  }

  public void requireCanEnterRoom(User user) {
    if (!canEnterRoom(user)) {
      throw new TripFitException(UserErrorCode.SCHEDULE_ENTRY_REQUIRED);
    }
  }

  // @TripMemberOnly / @TripOwnerOnly 인터셉터용 — userId로 로드 후 게이트
  public void requireCanEnterRoom(UUID userId) {
    User user =
        userRepository
            .findById(userId)
            .orElseThrow(() -> new TripFitException(AuthErrorCode.AUTH_FORBIDDEN));
    requireCanEnterRoom(user);
  }

  // Skip+0행 / create·join — 일정 없으면 is_all_free=true (이미 일정이면 유지)
  public void markAllFreeIfNoSchedules(User user) {
    if (!hasPreSchedule(user.getId())) {
      user.setAllFree(true);
    }
  }

  // 일정 추가 시 is_all_free=false (D-JOIN-CLEAR)
  public void clearAllFreeOnScheduleAdded(User user) {
    if (user.isAllFree()) {
      user.setAllFree(false);
    }
  }

  // 일정 CLEAR 후 둘 다 0행 → is_all_free=true
  public void markAllFreeIfSchedulesCleared(User user) {
    if (!hasPreSchedule(user.getId())) {
      user.setAllFree(true);
    }
  }
}
