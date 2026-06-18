#!/usr/bin/env bash
set -euo pipefail

echo "==> Cricket Coach Simulator — local setup"

if [ ! -f .env ]; then
  cp .env.example .env
  echo "Created .env from .env.example — update secrets before running"
fi

for cmd in docker go python3 flutter; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "WARNING: $cmd not found — install it before running the affected service"
  fi
done

echo "==> Installing Go deps"
(cd services/api-go && go mod download)

echo "==> Installing Python deps"
(cd services/ai-service && python3 -m venv .venv && .venv/bin/pip install -r requirements.txt -q)

echo "==> Installing Admin Portal deps"
(cd apps/admin-portal && npm install)

echo "==> Installing Flutter deps"
(cd apps/coach-app && flutter pub get)

echo ""
echo "Setup complete. Run: docker compose up -d"
