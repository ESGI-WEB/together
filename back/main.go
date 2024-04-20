package main

import (
	"fmt"
	"github.com/gorilla/mux"
	"net/http"
	"os"
)

func HomeHandler(res http.ResponseWriter, req *http.Request) {
	res.Write([]byte("Hello World."))
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/", HomeHandler)
	http.Handle("/", router)
	addr := "0.0.0.0:" + getEnv("PORT", "8080")
	fmt.Printf("Listening on %s\n", addr)
	http.ListenAndServe(addr, router)
}
