# 기능 스펙 (`docs/specs/`)

구현 **전**에 작성하는 기능·리팩터 설계 문서입니다.

## 작성 방법

1. Cursor에서 `specify` 스킬 사용 (또는 Plan 모드)
2. 템플릿: [`.cursor/skills/specify/references/spec-template.md`](../../.cursor/skills/specify/references/spec-template.md)
3. 파일명: kebab-case — 예) `trip-room-create.md` (접미사 `mvp`, `phase`, `p2` 금지)
4. 상단 메타: `wave`, `implements`, `deferred` — [`waves.md`](../product/waves.md)
5. 사용자 승인 후 구현 시작

## wave 2 (Draft — 승인 대기)

| 스펙 | 범위 | 선행 |
|------|------|------|
| [`schedule-unified.md`](schedule-unified.md) | `schedule` A안 통합·CONDITION/AVAILABILITY API | wave 1 auth·onboarding |
| [`trip-room-api.md`](trip-room-api.md) | 여행방 CRUD·참여·Pin·일정 제출 | schedule-unified |
| [`trip-recommendation.md`](trip-recommendation.md) | 추천 4모드·TOP 3·확정·취소 | 위 2개 |

**구현 순서:** schedule-unified → trip-room-api → trip-recommendation (room의 PATCH는 recommendation hard DELETE hook 필요).

## 완료 후

- 스펙의 완료 기준 체크
- API·스키마 변경이 있으면 `docs/architecture/erd.md` 동기화 검토
