# Endpoint Catalog

All routes are under `/api/v1` unless noted.

## Auth

| Method | Path | Auth | Description |
|---|---|---|---|
| POST | `/auth/login` | Public | Issue JWT for coach/admin |
| GET | `/auth/me` | Bearer | Return current user profile |

## Bootstrap

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/bootstrap` | Bearer | App startup state gate |

## Coach Profile

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/coach/profile` | Bearer | Get coach profile |
| PUT | `/coach/profile` | Bearer | Update coach profile |
| PATCH | `/coach/profile/discovery-state` | Bearer | Update discovery/onboarding state |

## Match Setup

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/setup/catalog` | Bearer | Leagues, seasons, teams, venues, rules |
| POST | `/game/matches` | Bearer | Create new match |
| GET | `/game/matches/:matchID` | Bearer | Get match state |
| POST | `/matchmaking/start` | Bearer | Start matchmaking queue |

## Pre-Match

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/game/matches/:matchID/pre-match` | Bearer | Pre-match analysis |
| PUT | `/game/matches/:matchID/pre-match/plan` | Bearer | Save pre-match plan |

## Live Match

| Method | Path | Auth | Description |
|---|---|---|---|
| POST | `/game/matches/:matchID/simulate` | Bearer | Simulate ball/over/key-event |
| GET | `/game/matches/:matchID/scorecard` | Bearer | Live scorecard |
| GET | `/game/matches/:matchID/predictions` | Bearer | Win probability + projections |
| GET | `/available-coach-actions` | Bearer | Legal actions for current state |
| POST | `/coach-actions/preview` | Bearer | Preview action risk/reward |
| POST | `/coach-actions` | Bearer | Submit coach decision |
| GET | `/game/matches/:matchID/commentary` | Bearer | Commentary feed |

## Post-Match

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/post-match-report` | Bearer | Grade, timeline, missed opportunities |
| POST | `/replay-from-turning-point/:turningPointID` | Bearer | Replay from key moment |

## Player Intelligence

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/players/:playerID/intelligence` | Bearer | Full player profile + insights |
| GET | `/players/:playerID/wagon-wheel` | Bearer | Scoring zone tendencies |
| GET | `/matchups/batter/:batterID/bowler/:bowlerID` | Bearer | Head-to-head matchup |

## Leaderboard

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/leaderboards/current` | Bearer | Current season leaderboard |
| GET | `/leaderboards/me` | Bearer | Coach personal ranking |
| GET | `/leaderboards/overview` | Bearer | Summary + categories |
| GET | `/achievements/me` | Bearer | Coach achievements |

## Notifications

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/notifications` | Bearer | Notification list |
| POST | `/notifications/read-all` | Bearer | Mark all read |
| GET | `/notification-preferences` | Bearer | Get preferences |
| PUT | `/notification-preferences` | Bearer | Update preferences |

## Health

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/health` | Public | Liveness check |
| GET | `/ready` | Public | Readiness check |
| GET | `/api/v1/health/deep` | Admin | Deep health (DB, AI, providers) |

## Admin

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/admin/dashboard-summary` | Admin | Data ops metrics |
| GET/POST/PUT/DELETE | `/admin/{resource}` | Admin | CRUD for master data |
| POST | `/admin/imports/upload` | Admin | Upload Cricsheet JSON |
| GET | `/admin/review-queue` | Admin | Import validation review |
| GET | `/admin/alerts` | Admin | Operational alerts |
| POST | `/admin/alerts/:id/acknowledge` | Admin | Acknowledge alert |

## Swagger

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/docs` | Configurable | Swagger UI |
| GET | `/openapi.yaml` | Configurable | OpenAPI spec |
