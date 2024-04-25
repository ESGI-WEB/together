package utils

import "os"

// LookupEnv always returns a string no int or whatever

func GetEnv(key string, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}
