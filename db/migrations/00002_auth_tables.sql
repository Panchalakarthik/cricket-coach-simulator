-- +goose Up
CREATE TABLE auth.users (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email         TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  role          TEXT NOT NULL DEFAULT 'coach' CHECK (role IN ('coach','admin','super_admin','data_admin','viewer')),
  is_active     BOOLEAN NOT NULL DEFAULT true,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE auth.coach_profiles (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id              UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name         TEXT NOT NULL,
  personality          JSONB,
  preferred_league_id  UUID,
  preferred_team_id    UUID,
  onboarding_completed BOOLEAN NOT NULL DEFAULT false,
  discovery_state      JSONB NOT NULL DEFAULT '{}',
  rating               INTEGER NOT NULL DEFAULT 1200,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE auth.achievements (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code        TEXT NOT NULL UNIQUE,
  name        TEXT NOT NULL,
  description TEXT NOT NULL,
  badge_type  TEXT NOT NULL
);

CREATE TABLE auth.user_achievements (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  achievement_id UUID NOT NULL REFERENCES auth.achievements(id),
  unlocked_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, achievement_id)
);

-- +goose Down
DROP TABLE IF EXISTS auth.user_achievements;
DROP TABLE IF EXISTS auth.achievements;
DROP TABLE IF EXISTS auth.coach_profiles;
DROP TABLE IF EXISTS auth.users;
