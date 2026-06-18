#!/usr/bin/env bash
set -euo pipefail

source .env 2>/dev/null || true

DB_URL="postgres://${POSTGRES_USER:-cricket_coach}:${POSTGRES_PASSWORD:-changeme_local}@${POSTGRES_HOST:-localhost}:${POSTGRES_PORT:-5432}/${POSTGRES_DB:-cricket_coach}?sslmode=disable"

echo "==> Running seeds"
for f in db/seeds/*.sql; do
  echo "  -> $f"
  psql "$DB_URL" -f "$f"
done
echo "Seeds complete."
