package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"

	"github.com/Panchalakarthik/cricket-coach-simulator/services/api-go/internal/config"
	"github.com/Panchalakarthik/cricket-coach-simulator/services/api-go/internal/server"
)

func main() {
	_ = godotenv.Load("../../.env")

	cfg, err := config.Load()
	if err != nil {
		fmt.Fprintf(os.Stderr, "config error: %v\n", err)
		os.Exit(1)
	}

	srv := server.New(cfg)

	addr := ":" + cfg.Port
	log.Printf("api-go listening on %s", addr)
	if err := http.ListenAndServe(addr, srv); err != nil {
		log.Fatalf("listen: %v", err)
	}
}
