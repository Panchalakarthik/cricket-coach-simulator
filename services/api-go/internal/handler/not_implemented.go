package handler

import (
	"encoding/json"
	"net/http"
)

func NotImplemented(name string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusNotImplemented)
		json.NewEncoder(w).Encode(map[string]string{
			"error":   "not_implemented",
			"handler": name,
		})
	}
}
