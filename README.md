# Cricket Coach Simulator

A tactical cricket coaching simulation game. Be the coach, not the spectator.

## Services

| Service | Dir | Language | Port |
|---|---|---|---|
| REST API | `services/api-go` | Go 1.22 | 8080 |
| AI Service | `services/ai-service` | Python 3.11 | 8000 |
| Admin Portal | `apps/admin-portal` | React + Vite | 5173 |
| Coach App | `apps/coach-app` | Flutter | 3000 (web) |
| PostgreSQL | — | — | 5432 |

## Quick Start

```bash
cp .env.example .env
# Edit .env — set JWT_SECRET (32+ chars) and ANTHROPIC_API_KEY
bash scripts/setup.sh
docker compose up -d
```

## Docs

- [Endpoint Catalog](docs/api/ENDPOINT_CATALOG.md)
- [Implementation Plans](docs/superpowers/plans/)

## Development

Each service can be run independently:

```bash
# Go API
cd services/api-go && make run

# Python AI Service
cd services/ai-service && uvicorn app.main:app --reload

# React Admin Portal
cd apps/admin-portal && npm run dev

# Flutter Coach App
cd apps/coach-app && flutter run -d web-server
```
