-- +goose Up
CREATE TABLE game.matches (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  league_id        UUID NOT NULL REFERENCES master.leagues(id),
  season_id        UUID NOT NULL REFERENCES master.seasons(id),
  home_team_id     UUID NOT NULL REFERENCES master.teams(id),
  away_team_id     UUID NOT NULL REFERENCES master.teams(id),
  venue_id         UUID REFERENCES master.venues(id),
  format_id        UUID REFERENCES master.match_formats(id),
  rules_id         UUID REFERENCES master.match_rules(id),
  coach_user_id    UUID NOT NULL REFERENCES auth.users(id),
  opponent_user_id UUID REFERENCES auth.users(id),
  bot_profile_id   UUID,
  status           TEXT NOT NULL DEFAULT 'setup' CHECK (status IN ('setup','pre_match','live','completed','abandoned')),
  mode             TEXT NOT NULL DEFAULT 'play_match' CHECK (mode IN ('play_match','challenge','scenario')),
  seed             BIGINT NOT NULL DEFAULT extract(epoch from now())::BIGINT,
  config_version   TEXT NOT NULL DEFAULT 'v1',
  toss_winner      TEXT,
  toss_choice      TEXT,
  pre_match_plan   JSONB NOT NULL DEFAULT '{}',
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE game.match_innings (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id        UUID NOT NULL REFERENCES game.matches(id) ON DELETE CASCADE,
  innings_num     INTEGER NOT NULL CHECK (innings_num IN (1, 2)),
  batting_team_id UUID NOT NULL REFERENCES master.teams(id),
  bowling_team_id UUID NOT NULL REFERENCES master.teams(id),
  status          TEXT NOT NULL DEFAULT 'not_started',
  runs            INTEGER NOT NULL DEFAULT 0,
  wickets         INTEGER NOT NULL DEFAULT 0,
  overs           NUMERIC(4,1) NOT NULL DEFAULT 0,
  target          INTEGER,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (match_id, innings_num)
);

CREATE TABLE game.ball_events (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id     UUID NOT NULL REFERENCES game.matches(id) ON DELETE CASCADE,
  innings_id   UUID NOT NULL REFERENCES game.match_innings(id) ON DELETE CASCADE,
  over_num     INTEGER NOT NULL,
  ball_num     INTEGER NOT NULL,
  batter_id    UUID REFERENCES master.players(id),
  bowler_id    UUID REFERENCES master.players(id),
  runs         INTEGER NOT NULL DEFAULT 0,
  extras       JSONB NOT NULL DEFAULT '{}',
  outcome_type TEXT NOT NULL,
  is_wicket    BOOLEAN NOT NULL DEFAULT false,
  wicket_type  TEXT,
  fielder_id   UUID REFERENCES master.players(id),
  raw_outcome  JSONB NOT NULL DEFAULT '{}',
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE game.coach_decisions (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id              UUID NOT NULL REFERENCES game.matches(id) ON DELETE CASCADE,
  decision_type         TEXT NOT NULL,
  decision_data         JSONB NOT NULL DEFAULT '{}',
  over_at_decision      NUMERIC(4,1),
  wickets_at_decision   INTEGER,
  runs_at_decision      INTEGER,
  impact_runs           INTEGER,
  impact_win_prob_delta NUMERIC(5,4),
  attribution_status    TEXT NOT NULL DEFAULT 'pending' CHECK (attribution_status IN ('pending','attributed','insufficient_data')),
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE game.win_probability_snapshots (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id       UUID NOT NULL REFERENCES game.matches(id) ON DELETE CASCADE,
  innings_id     UUID NOT NULL REFERENCES game.match_innings(id) ON DELETE CASCADE,
  over_num       INTEGER NOT NULL,
  ball_num       INTEGER NOT NULL,
  home_win_prob  NUMERIC(5,4) NOT NULL,
  away_win_prob  NUMERIC(5,4) NOT NULL,
  pressure_index NUMERIC(5,4),
  momentum       NUMERIC(5,4),
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE game.post_match_reports (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id          UUID NOT NULL UNIQUE REFERENCES game.matches(id),
  coach_grade       TEXT NOT NULL,
  coach_score       NUMERIC(5,2) NOT NULL,
  decision_accuracy JSONB NOT NULL DEFAULT '{}',
  key_moments       JSONB NOT NULL DEFAULT '[]',
  summary_text      TEXT,
  share_card_data   JSONB NOT NULL DEFAULT '{}',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE game.bot_profiles (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name             TEXT NOT NULL,
  archetype        TEXT NOT NULL,
  difficulty       TEXT NOT NULL DEFAULT 'medium' CHECK (difficulty IN ('easy','medium','hard','expert')),
  strategy_sliders JSONB NOT NULL DEFAULT '{}',
  preferred_league_id UUID REFERENCES master.leagues(id),
  preferred_team_id   UUID REFERENCES master.teams(id),
  is_active        BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE game.bot_rivalry_memory (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  coach_user_id   UUID NOT NULL REFERENCES auth.users(id),
  bot_profile_id  UUID NOT NULL REFERENCES game.bot_profiles(id),
  matches_played  INTEGER NOT NULL DEFAULT 0,
  coach_wins      INTEGER NOT NULL DEFAULT 0,
  bot_wins        INTEGER NOT NULL DEFAULT 0,
  last_played_at  TIMESTAMPTZ,
  memory_data     JSONB NOT NULL DEFAULT '{}',
  UNIQUE (coach_user_id, bot_profile_id)
);

CREATE TABLE game.challenge_templates (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title        TEXT NOT NULL,
  description  TEXT NOT NULL,
  mode         TEXT NOT NULL DEFAULT 'challenge' CHECK (mode IN ('challenge','scenario')),
  start_state  JSONB NOT NULL DEFAULT '{}',
  reward_data  JSONB NOT NULL DEFAULT '{}',
  is_active    BOOLEAN NOT NULL DEFAULT true,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE game.challenge_instances (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id UUID NOT NULL REFERENCES game.challenge_templates(id),
  active_date DATE NOT NULL,
  UNIQUE (template_id, active_date)
);

CREATE TABLE game.challenge_attempts (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  instance_id     UUID NOT NULL REFERENCES game.challenge_instances(id),
  user_id         UUID NOT NULL REFERENCES auth.users(id),
  match_id        UUID REFERENCES game.matches(id),
  status          TEXT NOT NULL DEFAULT 'started' CHECK (status IN ('started','completed','abandoned')),
  result_data     JSONB NOT NULL DEFAULT '{}',
  started_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at    TIMESTAMPTZ,
  UNIQUE (instance_id, user_id)
);

-- Indexes for hot query paths
CREATE INDEX idx_ball_events_match ON game.ball_events (match_id, innings_id, over_num, ball_num);
CREATE INDEX idx_decisions_match ON game.coach_decisions (match_id);
CREATE INDEX idx_wp_snapshots_match ON game.win_probability_snapshots (match_id, innings_id);
CREATE INDEX idx_matches_coach ON game.matches (coach_user_id, status);

-- +goose Down
DROP TABLE IF EXISTS game.challenge_attempts;
DROP TABLE IF EXISTS game.challenge_instances;
DROP TABLE IF EXISTS game.challenge_templates;
DROP TABLE IF EXISTS game.bot_rivalry_memory;
DROP TABLE IF EXISTS game.bot_profiles;
DROP TABLE IF EXISTS game.post_match_reports;
DROP TABLE IF EXISTS game.win_probability_snapshots;
DROP TABLE IF EXISTS game.coach_decisions;
DROP TABLE IF EXISTS game.ball_events;
DROP TABLE IF EXISTS game.match_innings;
DROP TABLE IF EXISTS game.matches;
