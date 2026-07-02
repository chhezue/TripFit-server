#!/usr/bin/env bash
# GitHub labels + milestones — wave 체계 (재실행 가능)
# Requires: gh auth login
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "FAIL: gh CLI required — https://cli.github.com/"
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "FAIL: run 'gh auth login' first"
  exit 1
fi

REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner)"
echo "[github-bootstrap] repo: $REPO"

create_label() {
  local name="$1"
  local color="$2"
  local description="${3:-}"
  gh label create "$name" --color "$color" --description "$description" --force >/dev/null
  echo "  label: $name"
}

delete_label() {
  local name="$1"
  if gh label delete "$name" --yes 2>/dev/null; then
    echo "  deleted: $name"
  fi
}

echo "[github-bootstrap] removing legacy labels..."
LEGACY=(
  bug documentation duplicate enhancement feature blocked
  "good first issue" "help wanted" invalid question wontfix
  "type: feature" "type: bug" "type: chore" "type: docs"
  "priority: P0" "priority: P1" "priority: P2" "priority: out"
  "size: S" "size: M" "size: T"
)
for label in "${LEGACY[@]}"; do
  delete_label "$label"
done

echo "[github-bootstrap] labels (wave / kind / area / meta)..."
create_label "wave:1" "B60205" "기반 — 인증·API·배포"
create_label "wave:2" "0E8A16" "핵심 — 여행방·일정·추천·확정"
create_label "wave:3" "D93F0B" "마무리 — 알림·달력·공유"
create_label "wave:4" "FEF2C0" "이후 — 계정연결·고도화"

create_label "kind: feature" "0E8A16" "새 기능·API"
create_label "kind: bug"     "D73A4A" "버그·오동작"
create_label "kind: chore"   "FBCA04" "CI·리팩터·설정"
create_label "kind: docs"    "0075CA" "문서만"

create_label "area: api"     "1D76DB" "REST API · controller"
create_label "area: domain"  "5319E7" "엔티티 · 도메인"
create_label "area: deploy"  "B60205" "Docker · EC2 · CI"
create_label "area: docs"    "C5DEF5" "docs/ 기획·스펙"
create_label "area: infra"   "666666" "DB · 설정 · 인프라"

create_label "meta: blocked"   "000000" "선행 작업 대기"
create_label "meta: duplicate" "CFD3D7" "중복 이슈"
create_label "meta: wontfix"   "FFFFFF" "수정 안 함"

create_label "priority: nice"  "EDEDED" "Must 완료 후 — Wave DoD 불필요"

upsert_milestone() {
  local title="$1"
  local description="$2"
  local number
  number="$(gh api "repos/${REPO}/milestones?state=all" \
    --jq ".[] | select(.title==\"${title}\") | .number" 2>/dev/null | head -1)"
  if [[ -n "$number" ]]; then
    gh api -X PATCH "repos/${REPO}/milestones/${number}" \
      -f title="${title}" \
      -f description="${description}" \
      -f state=open >/dev/null
    echo "  milestone: ${title} (#${number})"
    return 0
  fi
  gh api "repos/${REPO}/milestones" \
    -f title="${title}" \
    -f description="${description}" \
    -f state=open >/dev/null
  echo "  milestone: ${title} (created)"
}

close_milestone() {
  local title="$1"
  local number
  number="$(gh api "repos/${REPO}/milestones?state=all" \
    --jq ".[] | select(.title==\"${title}\") | .number" 2>/dev/null | head -1)"
  if [[ -n "$number" ]]; then
    gh api -X PATCH "repos/${REPO}/milestones/${number}" -f state=closed >/dev/null
    echo "  closed: ${title}"
  fi
}

echo "[github-bootstrap] milestones..."
for old in \
  "MVP-1 — 여행방·일정·추천 (P0)" \
  "MVP-2 — 알림·시각화 (P1)" \
  "MVP-3 — 편의·고도화 (P2)" \
  "Foundation — 인증·공통 API" \
  "MVP — 여행방·참여" \
  "MVP — 일정·조건·추천" \
  "MVP — 확정·시각화" \
  "MVP — 알림·공유 (P1)" \
  "Backlog — P2+"; do
  close_milestone "$old"
done

upsert_milestone "Wave 1 — 준비" \
  "인증·JWT·API 규약·배포. docs/product/waves.md · docs/product/development-wave.md"
upsert_milestone "Wave 2 — 핵심 MVP" \
  "여행방·참여·일정·조건·추천·확정. docs/product/waves.md · docs/product/development-wave.md"
upsert_milestone "Wave 3 — 출시 UX" \
  "알림·달력·공유. docs/product/waves.md · docs/product/development-wave.md"
upsert_milestone "Wave 4 — 운영·확장" \
  "계정연결·RTR·Apple S2S·고도화. docs/product/waves.md · docs/product/development-wave.md"

echo "[github-bootstrap] done — run scripts/github-sync-issues.sh to fix open issues"
