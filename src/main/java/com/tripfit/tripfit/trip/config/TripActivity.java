package com.tripfit.tripfit.trip.config;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/** L1 touch 대상 유스케이스 — {@link TripActivityAspect}가 {@code last_activity_at} 갱신 (#26). */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface TripActivity {

  /** 메서드 파라미터 이름(UUID tripId). {@link #tripIdFromReturn()} 와 배타. */
  String tripIdParam() default "";

  /** 반환 {@code TripDetailResponse.tripId()} 사용 (신규 join 등). */
  boolean tripIdFromReturn() default false;
}
