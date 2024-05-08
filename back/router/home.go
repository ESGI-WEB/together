package router

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
)

type HelloRouter struct{}

func (r *HelloRouter) SetupRoutes(e *echo.Echo) {
	helloController := controllers.NewHelloController()

	e.GET("/", helloController.Hello)
}
