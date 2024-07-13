package tests

import (
	"os"
	"testing"
	"together/database"
)

// Global database instance for tests
var testDB *database.DB

func TestMain(m *testing.M) {
	os.Exit(testMain(m))
}

func testMain(m *testing.M) int {
	setupTestDB()
	defer tearDownTestDB()

	tx := database.CurrentDatabase.Begin()
	database.CurrentDatabase = tx
	defer database.CurrentDatabase.Rollback()

	return m.Run()
}

func setupTestDB() {
	// Use SQLite in memory for testing
	testDB, _ = database.InitDB()

	// auto migrate database
	_ = testDB.AutoMigrate()
}

func tearDownTestDB() {
	_ = testDB.Close()
}
