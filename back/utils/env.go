package utils

import "os"

func GetEnv(key string, fallback interface{}) interface{} {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}
