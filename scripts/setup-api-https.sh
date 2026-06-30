#!/usr/bin/env bash
# api.tripfit.online — 백엔드 스택 배포 + Let's Encrypt HTTPS (EC2 A 일괄)
#
# 사전 조건:
#   - Route 53: api.tripfit.online A → 이 EC2 Elastic IP
#   - EC2 SG: Inbound 80, 443
#   - deploy/app/.env 설정 (MYSQL_HOST, GHCR_IMAGE)
#   - export SPRING_DATASOURCE_USERNAME / SPRING_DATASOURCE_PASSWORD
#   - export CERTBOT_EMAIL=codus5068@naver.com
#
# 사용:
#   ./scripts/setup-api-https.sh
#   ./scripts/setup-api-https.sh --skip-tls    # HTTPS 발급 생략 (임시 self-signed만)
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKIP_TLS=0
DOMAIN="${CERTBOT_DOMAIN:-api.tripfit.online}"

for arg in "$@"; do
  case "$arg" in
    --skip-tls) SKIP_TLS=1 ;;
    -h|--help)
      echo "Usage: CERTBOT_EMAIL=codus5068@naver.com $0 [--skip-tls]"
      exit 0
      ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

log() {
  printf '[setup-api-https] %s\n' "$*"
}

log "step 1/3 — deploy API stack (nginx + certbot + app)"
"${ROOT_DIR}/scripts/ec2-deploy-app.sh"

if [[ "$SKIP_TLS" -eq 1 ]]; then
  log "skip TLS (--skip-tls)"
  log "done (HTTP only / self-signed HTTPS). Run init-letsencrypt.sh later."
  exit 0
fi

: "${CERTBOT_EMAIL:?CERTBOT_EMAIL is required for Let's Encrypt (e.g. export CERTBOT_EMAIL=codus5068@naver.com)}"

log "step 2/3 — DNS check for ${DOMAIN}"
if command -v dig >/dev/null 2>&1; then
  resolved="$(dig +short "${DOMAIN}" A 2>/dev/null | head -1 || true)"
  if [[ -z "$resolved" ]]; then
    log "WARN: ${DOMAIN} does not resolve yet — wait for Route 53 propagation"
  else
    log "OK ${DOMAIN} → ${resolved}"
  fi
fi

log "step 3/3 — Let's Encrypt certificate"
"${ROOT_DIR}/scripts/init-letsencrypt.sh"

VERIFY_TLS=true "${ROOT_DIR}/scripts/verify-deploy-app.sh"

log "done — https://${DOMAIN}/health"
