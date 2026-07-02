#!/usr/bin/env bash
# wave 2 GitHub issues — SSOT는 GitHub + docs/specs/README.md
# 재실행 시 제목 중복이면 skip. (2026-07-17: #11·#17 Closed, #12·#13·#19·#20 Open)
set -euo pipefail

if ! gh auth status >/dev/null 2>&1; then
  echo "FAIL: run 'gh auth login' first"
  exit 1
fi

REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner)"
echo "[github-wave2-issues] repo: $REPO"
echo "Wave 2 issues exist — 라벨·마일스톤 동기화: ./scripts/github-sync-issues.sh"
echo "Must vs 후속: docs/product/waves.md § wave 2 — 핵심 Must vs 후속"
echo "Use: gh issue list --label wave:2 --state all"
