-- +goose Up
CREATE TABLE analytics.app_events (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  event_name TEXT NOT NULL,
  properties JSONB NOT NULL DEFAULT '{}',
  platform   TEXT,
  session_id TEXT,
  request_id TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_app_events_user ON analytics.app_events (user_id);
CREATE INDEX idx_app_events_name ON analytics.app_events (event_name);
CREATE INDEX idx_app_events_created ON analytics.app_events (created_at DESC);

-- +goose Down
DROP TABLE IF EXISTS analytics.app_events;
