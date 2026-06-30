#!/usr/bin/env bash
# 인증서·DH params가 없으면 임시 self-signed 생성 (nginx 443 기동용)
# 실제 운영 인증서: scripts/init-letsencrypt.sh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEPLOY_DIR="${DEPLOY_DIR:-$ROOT_DIR/deploy/app}"
PRIMARY_DOMAIN="${CERTBOT_DOMAIN:-api.tripfit.online}"
RSA_KEY_SIZE="${CERTBOT_RSA_KEY_SIZE:-4096}"

log() {
  printf '[ensure-ssl-certs] %s\n' "$*"
}

cd "$DEPLOY_DIR"

log "ensuring DH params"
docker compose run --rm --entrypoint sh certbot -c '
  if [ ! -f /etc/letsencrypt/ssl-dhparams.pem ]; then
    curl -fsS https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem \
      -o /etc/letsencrypt/ssl-dhparams.pem \
      || openssl dhparam -out /etc/letsencrypt/ssl-dhparams.pem 2048
  fi
'

if docker compose run --rm --entrypoint "test -f /etc/letsencrypt/live/${PRIMARY_DOMAIN}/fullchain.pem" certbot 2>/dev/null; then
  log "OK certificate exists: ${PRIMARY_DOMAIN}"
  exit 0
fi

log "WARN no certificate — creating temporary self-signed (run init-letsencrypt.sh)"
path="/etc/letsencrypt/live/${PRIMARY_DOMAIN}"
docker compose run --rm --entrypoint "\
  mkdir -p '${path}' && \
  openssl req -x509 -nodes -newkey rsa:${RSA_KEY_SIZE} -days 30\
    -keyout '${path}/privkey.pem' \
    -out '${path}/fullchain.pem' \
    -subj '/CN=${PRIMARY_DOMAIN}'" certbot

log "temporary cert created — browsers will warn until init-letsencrypt.sh runs"
