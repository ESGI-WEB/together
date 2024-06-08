package main

import (
	"fmt"

	"github.com/labstack/echo/v4"
	"github.com/labstack/gommon/log"
	"together/database"
	"together/routers"
	"together/swagger"
	"together/utils"
)

var appRouters = []routers.Router{
	&routers.HelloRouter{},
	&routers.UserRouter{},
	&routers.SecurityRouter{},
	&routers.FeatureRouter{},
	&routers.EventRouter{},
	&routers.EventTypeRouter{},
	&routers.AddressRouter{},
	&routers.GroupRouter{},
}

func main() {
	fmt.Println("Starting server...")

	e := echo.New()
	e.Logger.SetLevel(log.DEBUG)

	// Swagger configuration for routes
	securitySwagger := swagger.SetupSecuritySwagger()
	addressSwagger := swagger.SetupAddressSwagger()
	eventSwagger := swagger.SetupEventSwagger()

	swagger.RegisterSwaggerRoutes(e, securitySwagger, addressSwagger, eventSwagger)

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

	// Initialize database
	newDB, err := database.InitDB()
	if err != nil {
		e.Logger.Fatal(err)
		return
	}
	defer newDB.CloseDB()

	// Auto migrate database
	err = newDB.AutoMigrate()
	if err != nil {
		e.Logger.Fatal(err)
		return
	}

	// Load routes
	routers.LoadRoutes(e, appRouters...)

	// Serve static files for Flutter web
	e.Static("/app", utils.GetEnv("FLUTTER_BUILD_PATH", "flutter_build")+"/web")

	addr := "0.0.0.0:" + utils.GetEnv("PORT", "8080")
	e.Logger.Fatal(e.Start(addr))
	fmt.Printf("Listening on %s\n", addr)
}
