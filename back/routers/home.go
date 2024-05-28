package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
)

type HelloRouter struct{}

func (r *HelloRouter) SetupRoutes(e *echo.Echo) {
	helloController := controllers.NewHelloController()
	messageController := controllers.NewMessageController()

	e.GET("/", helloController.Hello)
	e.GET("/ws", messageController.Hello, middlewares.AuthenticationMiddleware)
	e.GET("/admin/ping", helloController.HelloAdmin, middlewares.AuthenticationMiddleware)
}
