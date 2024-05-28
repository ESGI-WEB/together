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
	&routers.FeatureRouter{},
}

func main() {
	fmt.Println("Starting server...")

	e := echo.New()

	// cors authorize flutter web dev
	if utils.GetEnv("APP_MODE", "production") == "development" {
		e.Use(func(next echo.HandlerFunc) echo.HandlerFunc {
			return func(c echo.Context) error {
				c.Response().Header().Set("Access-Control-Allow-Origin", "*")
				c.Response().Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE")
				c.Response().Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
				return next(c)
			}
		})
	}

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

	e.Static("/app", utils.GetEnv("FLUTTER_BUILD_PATH", "flutter_build")+"/web")

	addr := "0.0.0.0:" + utils.GetEnv("PORT", "8080")
	e.Logger.Fatal(e.Start(addr))
	fmt.Printf("Listening on %s\n", addr)
}
