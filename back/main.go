package main

import (
	"fmt"
	"together/services"

	"github.com/labstack/echo/v4"
	"github.com/labstack/gommon/log"
	"together/database"
	"together/routers"
	"together/swagger"
	"together/utils"
)

var webSocketService = services.NewWebSocketService()

var appRouters = []routers.Router{
	&routers.HelloRouter{},
	&routers.UserRouter{},
	&routers.SecurityRouter{},
	&routers.FeatureRouter{},
	&routers.EventRouter{},
	&routers.EventTypeRouter{},
	&routers.AddressRouter{},
	&routers.GroupRouter{},
	&routers.EventTypeRouter{},
	&routers.AdminRouter{},
	&routers.StorageRouter{},
	&routers.MessageRouter{},
	&routers.WebSocketRouter{},
}

func main() {
	fmt.Println("Starting server...")

	e := echo.New()
	e.Logger.SetLevel(log.DEBUG)

	// Set up Swagger routes
	swagger.SetupSwaggerRoutes(e)

	// CORS authorize Flutter web dev
	fmt.Printf("APP_MODE: %s\n", utils.GetEnv("APP_MODE", "production"))
	if utils.GetEnv("APP_MODE", "production") == "development" {
		e.Use(func(next echo.HandlerFunc) echo.HandlerFunc {
			return func(c echo.Context) error {
				c.Response().Header().Set("Access-Control-Allow-Origin", "*")
				c.Response().Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, PATCH, DELETE")
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

	// Load routes
	routers.LoadRoutes(e, appRouters...)

	// Serve static files for Flutter web
	e.Static("/app", utils.GetEnv("FLUTTER_BUILD_PATH", "flutter_build")+"/web")

	e.Static("/public", "public")

	addr := "0.0.0.0:" + utils.GetEnv("PORT", "8080")
	e.Logger.Fatal(e.Start(addr))
	fmt.Printf("Listening on %s\n", addr)
}
