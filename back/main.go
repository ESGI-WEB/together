package main

import (
	"fmt"
	"github.com/labstack/echo/v4"
	"together/database"
	"together/routers"
	"together/utils"
)

var appRouters = []routers.Router{
	&routers.HelloRouter{},
	&routers.UserRouter{},
	&routers.SecurityRouter{},
	&routers.GroupRouter{},
}

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

	routers.LoadRoutes(e, appRouters...)

	addr := "0.0.0.0:" + utils.GetEnv("PORT", "8080")
	e.Logger.Fatal(e.Start(addr))
	fmt.Printf("Listening on %s\n", addr)
}
