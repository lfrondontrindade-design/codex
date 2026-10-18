#!/usr/bin/env bash
set -euo pipefail
image='gosom/google-maps-scraper@sha256:e205c02913c5a69c16fc2094b8e5b194a2f655166d2c1126d50548d216e6b1b2'
mkdir -p /workspace/gmaps-data
if docker container inspect codex-google-maps-scraper >/dev/null 2>&1; then
  docker start codex-google-maps-scraper >/dev/null
else
  docker run -d --name codex-google-maps-scraper -p 127.0.0.1:8080:8080 -v /workspace/gmaps-data:/gmapsdata "$image" -data-folder /gmapsdata >/dev/null
fi
for attempt in {1..20}; do
  if curl -fsS http://127.0.0.1:8080/api/v1/jobs >/dev/null; then
    echo 'Google Maps Scraper: API local respondendo na porta 8080.'
    exit 0
  fi
  sleep 1
done
docker logs --tail 30 codex-google-maps-scraper
exit 1
