#!/usr/bin/env bash
# Download the newest app image and restart the app if it changed.
set -euo pipefail
cd /opt/task-tracker

echo "Pulling the newest image..."
docker compose pull app

echo "Starting..."
docker compose up -d

echo "Waiting for the app to be healthy..."
for _ in $(seq 1 45); do
  if curl -fsS http://127.0.0.1:8080/actuator/health > /dev/null 2>&1; then
    echo "Deploy OK"
    docker image prune -f > /dev/null
    exit 0
  fi
  sleep 2
done

echo "Deploy FAILED: app is not healthy" >&2
docker compose logs app --tail 50 >&2
exit 1
