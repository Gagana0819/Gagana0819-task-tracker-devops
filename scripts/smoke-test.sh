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
check "list tasks" 200 "$BASE_URL/api/tasks"
check "unknown id is 404" 404 "$BASE_URL/api/tasks/999999"
check "blank title is rejected" 400 -X POST "$BASE_URL/api/tasks" \
      -H "Content-Type: application/json" -d '{"title":""}'

exit $FAILED

