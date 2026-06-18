package server

import (
	"net/http"

	"github.com/go-chi/chi/v5"
	chimiddleware "github.com/go-chi/chi/v5/middleware"

	"github.com/Panchalakarthik/cricket-coach-simulator/services/api-go/internal/config"
	"github.com/Panchalakarthik/cricket-coach-simulator/services/api-go/internal/handler"
	"github.com/Panchalakarthik/cricket-coach-simulator/services/api-go/internal/middleware"
)

func New(cfg *config.Config) http.Handler {
	r := chi.NewRouter()

	r.Use(chimiddleware.Recoverer)
	r.Use(chimiddleware.Logger)
	r.Use(chimiddleware.Compress(5))
	r.Use(middleware.RequestID)

	r.Get("/health", handler.Health)
	r.Get("/ready", handler.Health)

	r.Route("/api/v1", func(r chi.Router) {
		r.Post("/auth/login", handler.NotImplemented("auth_login"))
		r.Get("/auth/me", handler.NotImplemented("auth_me"))

		r.Group(func(r chi.Router) {
			r.Use(middleware.Auth(cfg.JWTSecret))

			r.Get("/bootstrap", handler.NotImplemented("bootstrap"))

			r.Get("/setup/catalog", handler.NotImplemented("setup_catalog"))

			r.Get("/coach/profile", handler.NotImplemented("coach_profile_get"))
			r.Put("/coach/profile", handler.NotImplemented("coach_profile_put"))
			r.Patch("/coach/profile/discovery-state", handler.NotImplemented("coach_profile_discovery"))

			r.Post("/matchmaking/start", handler.NotImplemented("matchmaking_start"))
			r.Post("/game/matches", handler.NotImplemented("match_create"))
			r.Get("/game/matches/{matchID}", handler.NotImplemented("match_get"))
			r.Post("/game/matches/{matchID}/simulate", handler.NotImplemented("match_simulate"))
			r.Get("/game/matches/{matchID}/scorecard", handler.NotImplemented("scorecard_get"))
			r.Get("/game/matches/{matchID}/predictions", handler.NotImplemented("predictions_get"))
			r.Get("/game/matches/{matchID}/commentary", handler.NotImplemented("commentary_get"))

			r.Get("/available-coach-actions", handler.NotImplemented("coach_actions_available"))
			r.Post("/coach-actions/preview", handler.NotImplemented("coach_action_preview"))
			r.Post("/coach-actions", handler.NotImplemented("coach_action_submit"))

			r.Get("/post-match-report", handler.NotImplemented("post_match_report"))

			r.Get("/players/{playerID}/intelligence", handler.NotImplemented("player_intelligence"))
			r.Get("/players/{playerID}/wagon-wheel", handler.NotImplemented("wagon_wheel"))
			r.Get("/matchups/batter/{batterID}/bowler/{bowlerID}", handler.NotImplemented("matchup"))

			r.Get("/leaderboards/current", handler.NotImplemented("leaderboard_current"))
			r.Get("/leaderboards/me", handler.NotImplemented("leaderboard_me"))
			r.Get("/achievements/me", handler.NotImplemented("achievements_me"))

			r.Get("/notifications", handler.NotImplemented("notifications_list"))
			r.Post("/notifications/read-all", handler.NotImplemented("notifications_read_all"))

			r.Post("/analytics/events", handler.NotImplemented("analytics_events"))
		})
	})

	return r
}
