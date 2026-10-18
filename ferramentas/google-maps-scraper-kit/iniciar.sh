#!/usr/bin/env bash
set -euo pipefail
project=/workspace/google-maps-scraper-kit
config=/workspace/codex/ferramentas/google-maps-scraper-kit/compose.override.yaml
# Nginx usa um usuário sem privilégios e precisa ler os arquivos montados.
chmod -R a+rX "$project/frontend"
chmod a+r "$project/nginx.conf" "$project/scraper-proxy.inc"
docker compose -f "$project/docker-compose.yml" -f "$config" up -d
for attempt in {1..20}; do
  if curl -fsS http://127.0.0.1:8081/api/v1/jobs >/dev/null; then
    echo 'Kit: interface e API locais na porta 8081.'
    exit 0
  fi
  sleep 1
done
exit 1
