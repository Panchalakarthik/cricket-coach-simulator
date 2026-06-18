package config

import (
	"fmt"
	"os"
)

type Config struct {
	Port           string
	DatabaseURL    string
	JWTSecret      string
	CORSOrigins    string
	SwaggerEnabled bool
	AIServiceURL   string
	LogLevel       string
}

func Load() (*Config, error) {
	cfg := &Config{
		Port:           getEnv("PORT", "8080"),
		JWTSecret:      os.Getenv("JWT_SECRET"),
		CORSOrigins:    getEnv("CORS_ORIGINS", "http://localhost:5173"),
		SwaggerEnabled: getEnv("SWAGGER_ENABLED", "false") == "true",
		AIServiceURL:   getEnv("AI_SERVICE_URL", "http://localhost:8000"),
		LogLevel:       getEnv("LOG_LEVEL", "info"),
	}

	host := getEnv("POSTGRES_HOST", "localhost")
	port := getEnv("POSTGRES_PORT", "5432")
	db := getEnv("POSTGRES_DB", "cricket_coach")
	user := getEnv("POSTGRES_USER", "cricket_coach")
	pass := os.Getenv("POSTGRES_PASSWORD")
	cfg.DatabaseURL = fmt.Sprintf(
		"postgres://%s:%s@%s:%s/%s?sslmode=disable",
		user, pass, host, port, db,
	)

	if cfg.JWTSecret == "" {
		return nil, fmt.Errorf("JWT_SECRET is required")
	}
	if len(cfg.JWTSecret) < 32 {
		return nil, fmt.Errorf("JWT_SECRET must be at least 32 characters")
	}

	return cfg, nil
}

func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}
