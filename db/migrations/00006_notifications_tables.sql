-- +goose Up
CREATE TABLE notifications.notifications (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  category     TEXT NOT NULL,
  title        TEXT NOT NULL,
  body         TEXT NOT NULL,
  deeplink     TEXT,
  is_read      BOOLEAN NOT NULL DEFAULT false,
  is_dismissed BOOLEAN NOT NULL DEFAULT false,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE notifications.preferences (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  prefs_json JSONB NOT NULL DEFAULT '{}'
);

CREATE INDEX idx_notifications_user_unread ON notifications.notifications (user_id) WHERE NOT is_read AND NOT is_dismissed;

-- +goose Down
DROP TABLE IF EXISTS notifications.preferences;
DROP TABLE IF EXISTS notifications.notifications;
