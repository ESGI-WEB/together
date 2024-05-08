package main

import (
	"fmt"
	"github.com/labstack/echo/v4"
	"together/database"
	"together/router"
	"together/utils"
)

func main() {
	fmt.Println("Starting server...")

	e := echo.New()

	// init database
	// can also be called in func init but defer must be called in main
	// so we keep everything together here
	newDB, err := database.InitDB()
	if err != nil {
		e.Logger.Fatal(err)
		return
	}
	defer newDB.CloseDB()

	// auto migrate database
	err = newDB.AutoMigrate()
	if err != nil {
		e.Logger.Fatal(err)
		return
	}

	router.LoadRoutes(e, &router.HelloRouter{}, &router.UserRouter{})

	addr := "0.0.0.0:" + utils.GetEnv("PORT", "8080")
	e.Logger.Fatal(e.Start(addr))
	fmt.Printf("Listening on %s\n", addr)
}
