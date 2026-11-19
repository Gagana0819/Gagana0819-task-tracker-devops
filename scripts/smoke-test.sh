#!/usr/bin/env bash
# Smoke test for the Task Tracker API.  Usage: ./scripts/smoke-test.sh [base-url]
set -euo pipefail

BASE_URL="${1:-http://localhost:8080}"
FAILED=0

check() {
  local name="$1" expected="$2"; shift 2
  local actual
  actual=$(curl -s -o /dev/null -w "%{http_code}" "$@" || true)
  if [[ "$actual" == "$expected" ]]; then
    echo "PASS  $name ($actual)"
  else
    echo "FAIL  $name (expected $expected, got $actual)"
    FAILED=1
  fi
}

check "health is up" 200 "$BASE_URL/actuator/health"
check "create task" 201 -X POST "$BASE_URL/api/tasks" \
      -H "Content-Type: application/json" -d '{"title":"smoke test"}'
# TODO 1: GET  /api/tasks          -> 200
# TODO 2: GET  /api/tasks/999999   -> 404
# TODO 3: POST {"title":""}        -> 400

exit $FAILED

