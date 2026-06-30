#!/usr/bin/env bash
# EC2 A에서 Spring 앱 배포 (GHCR pull + compose up)
# 사용: ./scripts/ec2-deploy-app.sh
#       GHCR_IMAGE=ghcr.io/owner/tripfit-server:tag ./scripts/ec2-deploy-app.sh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEPLOY_DIR="${DEPLOY_DIR:-$ROOT_DIR/deploy/app}"
cd "$DEPLOY_DIR"

if [[ -f .env ]]; then
  # shellcheck disable=SC1091
  set -a
  source .env
  set +a
fi

: "${GHCR_IMAGE:?GHCR_IMAGE is required (set in deploy/app/.env)}"
: "${SPRING_DATASOURCE_USERNAME:?SPRING_DATASOURCE_USERNAME is required (export or GitHub Secrets)}"
: "${SPRING_DATASOURCE_PASSWORD:?SPRING_DATASOURCE_PASSWORD is required (export or GitHub Secrets)}"

export SPRING_DATASOURCE_USERNAME SPRING_DATASOURCE_PASSWORD

APP_PORT="${APP_PORT:-8080}"

log() {
  printf '[ec2-deploy-app] %s\n' "$*"
}

docker logout ghcr.io 2>/dev/null || true
if [[ -n "${GHCR_PAT:-}" ]]; then
  : "${GHCR_USERNAME:?GHCR_USERNAME is required with GHCR_PAT}"
  log "logging in to ghcr.io as $GHCR_USERNAME"
  echo "$GHCR_PAT" | docker login ghcr.io -u "$GHCR_USERNAME" --password-stdin
else
  log "WARN: GHCR_PAT not set — private package pull will fail"
fi

log "pulling $GHCR_IMAGE"
docker compose pull app

log "starting app"
docker compose up -d app

log "waiting for readiness (port $APP_PORT)"
for _ in $(seq 1 24); do
  if curl -fsS "http://localhost:${APP_PORT}/actuator/health/readiness" >/dev/null; then
    log "OK readiness"
    exit 0
  fi
  sleep 5
done

log "FAIL readiness timeout"
docker logs tripfit-app 2>&1 | tail -80
exit 1
