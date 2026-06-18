.PHONY: run test build lint migrate-up migrate-down

run:
	go run ./cmd/api

test:
	go test ./... -v -race

build:
	go build -o bin/api ./cmd/api

lint:
	golangci-lint run ./...

migrate-up:
	goose -dir ../../db/migrations postgres "$(DATABASE_URL)" up

migrate-down:
	goose -dir ../../db/migrations postgres "$(DATABASE_URL)" down
