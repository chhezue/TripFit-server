#!/usr/bin/env bash
# wave 2 GitHub issues 생성 (스펙 3분할). 재실행 시 제목 중복이면 skip.
set -euo pipefail

if ! gh auth status >/dev/null 2>&1; then
  echo "FAIL: run 'gh auth login' first"
  exit 1
fi

REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner)"
MILESTONE="Wave 2 — 핵심"
echo "[github-wave2-issues] repo: $REPO"

issue_exists() {
  local title="$1"
  gh issue list --state all --search "in:title \"${title}\"" --json title \
    --jq ".[] | select(.title==\"${title}\") | .title" | grep -q .
}

create_issue() {
  local title="$1"
  local body="$2"
  if issue_exists "$title"; then
    echo "  skip (exists): ${title}"
    return 0
  fi
  gh issue create \
    --title "$title" \
    --body "$body" \
    --label "wave:2" \
    --label "kind: feature" \
    --label "area: api" \
    --milestone "$MILESTONE"
  echo "  created: ${title}"
}

create_issue "[Feat] schedule 통합 (A안) — CONDITION/AVAILABILITY API" "$(cat <<'EOF'
## 한 줄 요약

`user_condition`·`member_schedule` → ERD `schedule` A안 마이그레이션 및 User 전역 일정 API.

**스펙:** `docs/specs/schedule-unified.md`  
**선행:** #10 (온보딩), wave 1 auth  
**implements:** BR-TRIP-002~004,006, BR-USER-006,008

---

## 완료 기준

- [ ] `Schedule` JPA + 레거시 테이블 migration
- [ ] `PUT/GET /users/me/schedule/condition|availability`
- [ ] trip 멤버 availability-summary (status만, BR-TRIP-004)
- [ ] `./gradlew test` 통과
EOF
)"

create_issue "[Feat] 여행방 API — 생성·참여·Pin·일정 제출" "$(cat <<'EOF'
## 한 줄 요약

여행방 CRUD·초대 참여·홈 Pin·「일정 제출하기」→ RESPONDED.

**스펙:** `docs/specs/trip-room-api.md`  
**선행:** schedule-unified 이슈  
**implements:** BR-TRIP-001,008,009,013, BR-USER-001,002,007,009,010

---

## 완료 기준

- [ ] Trip/TripMember API (create, join, list, patch, delete soft)
- [ ] Pin PATCH, schedule submit → RESPONDED
- [ ] BR-TRIP-010 hook 지점 (recommendation DELETE — 후속 이슈)
- [ ] `./gradlew test` 통과
EOF
)"

create_issue "[Feat] 추천 4모드 · TOP 3 · 확정·취소" "$(cat <<'EOF'
## 한 줄 요약

기본/모두 참석/휴가 아끼기/확실하게 4모드 TOP 3 + 방장 확정·취소.

**스펙:** `docs/specs/trip-recommendation.md`  
**선행:** schedule-unified, trip-room-api  
**implements:** BR-TRIP-005,007,010,011,012

---

## 완료 기준

- [ ] POST/GET recommendations (4 modes)
- [ ] POST confirm (후보 또는 직접 날짜), POST cancel
- [ ] recommendation hard DELETE 정책 (BR-TRIP-010)
- [ ] RecommendationService 단위 테스트
- [ ] `./gradlew test` 통과
EOF
)"

echo "[github-wave2-issues] done"
