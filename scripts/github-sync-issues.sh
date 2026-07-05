#!/usr/bin/env bash
# Open issues → wave labels + milestones (재실행 가능)
set -euo pipefail

REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner)"
echo "[github-sync-issues] repo: $REPO"

strip_old_labels() {
  local n="$1"
  gh issue edit "$n" \
    --remove-label "type: feature" 2>/dev/null || true
  gh issue edit "$n" \
    --remove-label "priority: P0" --remove-label "priority: P1" \
    --remove-label "priority: P2" --remove-label "priority: out" 2>/dev/null || true
  gh issue edit "$n" \
    --remove-label "size: S" --remove-label "size: M" --remove-label "size: T" 2>/dev/null || true
}

set_issue() {
  local n="$1" wave="$2" milestone="$3"
  strip_old_labels "$n"
  gh issue edit "$n" \
    --add-label "wave:${wave}" \
    --add-label "kind: feature" \
    --add-label "area: api" \
    --milestone "$milestone"
  echo "  issue #${n} → wave:${wave}, ${milestone}"
}

# wave 1 — 기반
set_issue 1 1 "Wave 1 — 기반"
set_issue 3 1 "Wave 1 — 기반"

# wave 4 — 이후
set_issue 4 4 "Wave 4 — 이후"
set_issue 5 4 "Wave 4 — 이후"
set_issue 6 4 "Wave 4 — 이후"

# stale temp issue
if gh issue view 2 --json state -q .state 2>/dev/null | grep -q OPEN; then
  gh issue close 2 --comment "정리: 중복·임시 이슈" 2>/dev/null || true
  gh issue edit 2 --add-label "meta:duplicate" 2>/dev/null || true
  echo "  issue #2 closed"
fi

echo "[github-sync-issues] done"
