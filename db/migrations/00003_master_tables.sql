-- +goose Up
CREATE TABLE master.leagues (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  short_name TEXT NOT NULL UNIQUE,
  name       TEXT NOT NULL,
  country    TEXT NOT NULL,
  is_active  BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE master.seasons (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  league_id  UUID NOT NULL REFERENCES master.leagues(id),
  name       TEXT NOT NULL,
  year       INTEGER NOT NULL,
  is_active  BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE master.franchises (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name          TEXT NOT NULL,
  short_name    TEXT NOT NULL,
  logo_url      TEXT,
  home_venue_id UUID
);

CREATE TABLE master.teams (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  franchise_id UUID REFERENCES master.franchises(id),
  season_id    UUID NOT NULL REFERENCES master.seasons(id),
  name         TEXT NOT NULL,
  short_name   TEXT NOT NULL,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE master.venues (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name           TEXT NOT NULL,
  city           TEXT NOT NULL,
  country        TEXT NOT NULL,
  capacity       INTEGER,
  boundary_sizes JSONB,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE master.players (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name      TEXT NOT NULL,
  short_name     TEXT,
  date_of_birth  DATE,
  nationality    TEXT,
  batting_style  TEXT,
  bowling_style  TEXT,
  role           TEXT,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE master.player_profiles (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id       UUID NOT NULL REFERENCES master.players(id) ON DELETE CASCADE,
  season_id       UUID NOT NULL REFERENCES master.seasons(id),
  batting_rating  INTEGER NOT NULL DEFAULT 50,
  bowling_rating  INTEGER NOT NULL DEFAULT 50,
  form            INTEGER NOT NULL DEFAULT 50 CHECK (form BETWEEN 0 AND 100),
  fitness         INTEGER NOT NULL DEFAULT 100 CHECK (fitness BETWEEN 0 AND 100),
  confidence      INTEGER NOT NULL DEFAULT 50 CHECK (confidence BETWEEN 0 AND 100),
  phase_skills    JSONB NOT NULL DEFAULT '{}',
  scoring_zones   JSONB NOT NULL DEFAULT '{}',
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (player_id, season_id)
);

CREATE TABLE master.match_formats (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name            TEXT NOT NULL,
  overs           INTEGER NOT NULL,
  powerplay_overs INTEGER NOT NULL DEFAULT 6
);

CREATE TABLE master.match_rules (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  format_id  UUID NOT NULL REFERENCES master.match_formats(id),
  name       TEXT NOT NULL,
  rules_json JSONB NOT NULL DEFAULT '{}'
);

CREATE TABLE master.playing_conditions (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  venue_id    UUID REFERENCES master.venues(id),
  name        TEXT NOT NULL,
  conditions  JSONB NOT NULL DEFAULT '{}'
);

CREATE TABLE master.squads (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  team_id     UUID NOT NULL REFERENCES master.teams(id),
  player_id   UUID NOT NULL REFERENCES master.players(id),
  role        TEXT,
  is_impact   BOOLEAN NOT NULL DEFAULT false,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (team_id, player_id)
);

-- +goose Down
DROP TABLE IF EXISTS master.squads;
DROP TABLE IF EXISTS master.playing_conditions;
DROP TABLE IF EXISTS master.match_rules;
DROP TABLE IF EXISTS master.match_formats;
DROP TABLE IF EXISTS master.player_profiles;
DROP TABLE IF EXISTS master.players;
DROP TABLE IF EXISTS master.venues;
DROP TABLE IF EXISTS master.teams;
DROP TABLE IF EXISTS master.franchises;
DROP TABLE IF EXISTS master.seasons;
DROP TABLE IF EXISTS master.leagues;
