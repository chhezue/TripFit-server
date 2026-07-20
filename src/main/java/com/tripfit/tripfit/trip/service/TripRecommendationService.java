package com.tripfit.tripfit.trip.service;

import com.tripfit.tripfit.trip.config.TripActivity;
import com.tripfit.tripfit.trip.domain.RecommendationMode;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/** #13 추천·확정 유스케이스 — API·계산 로직은 #13에서 구현 (#26 L4 hook 위치). */
@Service
class TripRecommendationService {

  @Transactional
  @TripActivity(tripIdParam = "tripId")
  public void generateRecommendations(UUID tripId, UUID ownerId, RecommendationMode mode) {
    // TODO #13: BR-TRIP-005 — hard DELETE · TOP 3 INSERT · last_recommendation_mode
  }

  @Transactional
  @TripActivity(tripIdParam = "tripId")
  public void confirmSchedule(UUID tripId, UUID ownerId) {
    // TODO #13: BR-TRIP-007 — status=CONFIRMED · confirmedStartDate/EndDate
  }
}
