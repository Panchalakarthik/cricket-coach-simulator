-- +goose Up
CREATE TABLE leaderboard.seasons (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name       TEXT NOT NULL,
  is_active  BOOLEAN NOT NULL DEFAULT false,
  started_at TIMESTAMPTZ,
  ended_at   TIMESTAMPTZ
);

CREATE TABLE leaderboard.entries (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  season_id   UUID NOT NULL REFERENCES leaderboard.seasons(id),
  user_id     UUID NOT NULL REFERENCES auth.users(id),
  rating      INTEGER NOT NULL DEFAULT 1200,
  rank        INTEGER,
  wins        INTEGER NOT NULL DEFAULT 0,
  losses      INTEGER NOT NULL DEFAULT 0,
  draws       INTEGER NOT NULL DEFAULT 0,
  win_streak  INTEGER NOT NULL DEFAULT 0,
  human_wins  INTEGER NOT NULL DEFAULT 0,
  bot_wins    INTEGER NOT NULL DEFAULT 0,
  last_delta  INTEGER NOT NULL DEFAULT 0,
  is_excluded BOOLEAN NOT NULL DEFAULT false,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (season_id, user_id)
);

CREATE INDEX idx_leaderboard_entries_rank ON leaderboard.entries (season_id, rank ASC NULLS LAST) WHERE NOT is_excluded;

-- +goose Down
DROP TABLE IF EXISTS leaderboard.entries;
DROP TABLE IF EXISTS leaderboard.seasons;
