#!/usr/bin/env bash
set -euo pipefail
cd "${1:-.}"

docker-compose down --remove-orphans
docker-compose pull
docker-compose up -d --build
docker image prune -f || true