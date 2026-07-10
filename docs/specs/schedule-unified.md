# schedule 통합 (A안) — 근무·연차 + 가용성

> wave: 2  
> implements: BR-TRIP-002, BR-TRIP-003, BR-TRIP-004, BR-TRIP-006, BR-USER-006, BR-USER-008  
> deferred: Google Calendar OAuth (wave 4), B안 물리 2테이블 (`erd.md` §7), 외부 캘린더 자동 동기화  
> 상태: Draft  
> 선행: [`auth-social-login.md`](auth-social-login.md) (Approved), [`user-onboarding.md`](user-onboarding.md) (Approved)  
> 후속: [`trip-room-api.md`](trip-room-api.md), [`trip-recommendation.md`](trip-recommendation.md)

## 목표

레거시 `user_condition`·`member_schedule`(trip_member FK)를 ERD **`schedule` A안**으로 통합하고, User 전역 일정 API를 제공한다. trip별 응답은 **동일 AVAILABILITY 데이터**를 trip 희망 기간으로 필터해 사용한다 (BR-USER-008).

## 배경

- **현재 JPA:** `UserCondition` (`user_condition`), `MemberSchedule` (`member_schedule` → `trip_member_id`)
- **ERD SSOT:** `schedule` — `row_type`=`CONDITION`|`AVAILABILITY`, **`user_id` FK, trip FK 없음**
- **온보딩:** `user-onboarding.md`에서 CONDITION CRUD는 Deferred → **본 스펙에서 구현**
- **BR-USER-006:** `isScheduleRegistered=false`이면 trip 일정 입력 전 CONDITION 저장 필수
- **BR-USER-008:** CONDITION·AVAILABILITY 변경은 참여 중 **모든 trip** 추천 입력에 즉시 반영

### 관련 문서

| 문서 | 내용 |
|------|------|
| `docs/architecture/erd.md` | `schedule` 컬럼·제약 |
| `docs/product/business-rules/user.md` | BR-USER-006, 008 |
| `docs/product/business-rules/trip.md` | BR-TRIP-002~004, 006 |
| `docs/product/flows/schedule-edit.md` | 일정·조건 수정 플로우 |
| `docs/product/flows/trip-join.md` | CONDITION 게이트 → AVAILABILITY → 제출 |

## 요구사항

### Must Have

- [ ] JPA `Schedule` 엔티티 (`schedule` 테이블, `ScheduleRowType` enum)
- [ ] 레거시 제거: `UserCondition`, `MemberSchedule` 엔티티·리포지토리 삭제
- [ ] **Flyway 또는 수동 migration** (로컬·test): 기존 `user_condition` → `schedule` CONDITION, `member_schedule` → `schedule` AVAILABILITY (`user_id` = `trip_member.user_id`)
- [ ] user당 CONDITION **1행** upsert; AVAILABILITY `(user_id, schedule_date, time_slot)` UNIQUE
- [ ] CONDITION 저장 시 `user.isScheduleRegistered=true` (BR-USER-006)
- [ ] AVAILABILITY `note` — **본인 API만** 노출 (BR-TRIP-004)
- [ ] 타인 조회 API — `status`만 (POSSIBLE / IMPOSSIBLE / TBD), `note` 제외
- [ ] enum: `TimeSlot` (MORNING, AFTERNOON, EVENING), `ScheduleStatus` (기존 재사용)
- [ ] `./gradlew test` 통과

### Nice to Have

- [ ] CONDITION 삭제 API (MVP 필수 아님 — 수정 upsert만으로 충분)

### Out of Scope

- trip_member 연동·「일정 제출하기」→ `RESPONDED` — [`trip-room-api.md`](trip-room-api.md)
- 추천 재계산·hard DELETE — [`trip-recommendation.md`](trip-recommendation.md), BR-TRIP-010
- Google Calendar OAuth·토큰 저장
- B안 (`user_work_profile` + `user_availability`) 물리 분리

## API / 인터페이스

| Method | Path | Auth | 설명 |
|--------|------|------|------|
| GET | `/api/v1/users/me/schedule/condition` | JWT | 본인 CONDITION 조회 |
| PUT | `/api/v1/users/me/schedule/condition` | JWT | CONDITION upsert → `isScheduleRegistered=true` |
| GET | `/api/v1/users/me/schedule/availability` | JWT | 본인 AVAILABILITY 목록 (`startDate`, `endDate` query 필수) |
| PUT | `/api/v1/users/me/schedule/availability` | JWT | AVAILABILITY bulk upsert (본인, `note` 포함 가능) |
| GET | `/api/v1/trips/{tripId}/members/availability-summary` | JWT + trip_member | trip 기간 내 **타 참여자** 슬롯 — **status만** (BR-TRIP-004) |

> trip 본인 편집 UI는 `GET/PUT .../users/me/schedule/availability`에 `trip.startRange`~`endRange`를 query로 넘긴다. trip FK는 저장하지 않는다.

### `PUT /users/me/schedule/condition` 요청

```json
{
  "workDays": "MON,TUE,WED,THU,FRI",
  "workStartTime": "09:00:00",
  "workEndTime": "18:00:00",
  "maxVacationDays": 5,
  "vacationApplyPeriod": "1주 전",
  "halfVacationAvailable": true,
  "holidayRest": true
}
```

### `PUT /users/me/schedule/availability` 요청

```json
{
  "items": [
    {
      "scheduleDate": "2026-08-03",
      "timeSlot": "MORNING",
      "status": "POSSIBLE",
      "note": "반차 예정"
    }
  ]
}
```

### `GET .../members/availability-summary` 응답 (타인 데이터)

```json
{
  "data": {
    "members": [
      {
        "userId": 2,
        "displayName": "홍길동",
        "slots": [
          {
            "scheduleDate": "2026-08-03",
            "timeSlot": "MORNING",
            "status": "IMPOSSIBLE"
          }
        ]
      }
    ]
  }
}
```

`note` 필드 **없음**. 동명이인 `(2)` 표시는 BR-USER-009 — [`trip-room-api.md`](trip-room-api.md) 멤버 DTO.

### 주요 에러 코드

| HTTP | code | 조건 |
|------|------|------|
| 400 | `INVALID_INPUT` | 날짜·슬롯·status 누락/범위 밖 |
| 403 | `SCHEDULE_CONDITION_REQUIRED` | `[제안]` trip 일정 API 선행 호출 시 CONDITION 없음 (trip-room에서도 동일 코드 재사용) |
| 403 | `TRIP_ACCESS_DENIED` | trip_member 아님 |
| 404 | `TRIP_NOT_FOUND` | soft delete trip |

## 데이터 모델

- ERD: `docs/architecture/erd.md` § `schedule`
- **신규:** `Schedule` (`com.tripfit.tripfit.user.domain` 또는 `schedule` 패키지 — 구현 시 `user` 도메인 하위 권장)
- **삭제:** `UserCondition`, `MemberSchedule` 및 테이블

```
schedule
  id, user_id, row_type
  -- CONDITION columns (nullable when AVAILABILITY)
  work_days, work_start_time, work_end_time, max_vacation_days,
  vacation_apply_period, is_half_vacation_available, is_holiday_rest
  -- AVAILABILITY columns
  schedule_date, time_slot, status, note
  created_at, updated_at
```

### Migration 정책

1. `user_condition` 각 행 → `schedule` (`row_type=CONDITION`, 동일 user_id)
2. `member_schedule` 각 행 → `trip_member` join → `schedule` AVAILABILITY (`user_id`, date, slot, status, note)
3. 동일 `(user_id, schedule_date, time_slot)` 중복 시 **최신 `updated_at` 우선** `[제안]`
4. migration 후 레거시 테이블 drop (test profile은 ddl-auto/create-drop 또는 Flyway)

### Soft delete / FK

- `schedule` — User 소유, **soft delete 없음** (User 탈퇴 정책은 BR-USER-004 `[미정]`)
- trip soft delete와 **무관** — 데이터 유지

## 비즈니스 규칙

| BR | 적용 내용 | 구현 위치 (예정) |
|----|-----------|------------------|
| BR-TRIP-002 | 날짜×MORNING/AFTERNOON/EVENING | AVAILABILITY upsert 검증 |
| BR-TRIP-003 | POSSIBLE / IMPOSSIBLE / TBD | enum 검증 |
| BR-TRIP-004 | 타인 조회 status만 | `availability-summary` DTO |
| BR-TRIP-006 | CONDITION 1행 | upsert + 필드 검증 |
| BR-USER-006 | CONDITION 없으면 trip 일정 차단 | trip-room과 공유 게이트 |
| BR-USER-008 | trip FK 없음, 전역 데이터 | 엔티티 설계 |

## 검증 시나리오

### 정상

- [ ] CONDITION 최초 PUT → `isScheduleRegistered=true`, GET 반환
- [ ] AVAILABILITY bulk PUT → trip 기간 query GET 일치
- [ ] 멤버 A가 summary 조회 → 멤버 B의 `note` 미포함

### 엣지 · 실패

- [ ] CONDITION 없이 trip 쪽 일정 API → 403 `SCHEDULE_CONDITION_REQUIRED`
- [ ] trip 비참여자 summary → 403
- [ ] 잘못된 timeSlot → 400 `INVALID_INPUT`

### 수동 / 통합

- [ ] migration 후 기존 test/fixture 데이터 보존 (있을 경우)
- [ ] `@WebMvcTest` 또는 slice test — BR-TRIP-004 note 비노출

## 완료 기준

- [ ] `./gradlew test` 통과
- [ ] `./gradlew build` 성공
- [ ] OpenAPI `@Schema` — 엔티티·DTO·enum
- [ ] `user-onboarding.md` Deferred 「`user_condition` CRUD」→ 본 스펙 링크로 대체 가능
- [ ] `erd.md` 구현 상태 주석 갱신 (wave 2 schedule 완료)

## 리스크·미결정

| 항목 | 상태 | 비고 |
|------|------|------|
| BR-TRIP-006 숫자 상한 | `[미정]` | maxVacationDays 등 상한 — MVP는 null/양수만 검증 |
| migration 중복 AVAILABILITY | `[제안]` | 최신 updated_at 우선 |
| Flyway 도입 여부 | `[미정]` | wave 1은 ddl-auto; wave 2 migration 방식 팀 확인 |
| trip 기간 밖 AVAILABILITY 저장 | `[제안]` | 허용 (전역 캘린더). trip UI는 기간 필터만 |

## 변경 이력

| 날짜 | 변경 |
|------|------|
| 2026-07-08 | 초안 (schedule A안 통합) |
