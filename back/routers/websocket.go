package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
)

type WebSocketRouter struct{}

func (r *WebSocketRouter) SetupRoutes(e *echo.Echo) {
	webSocketController := controllers.NewWebSocketController()

	e.GET("/ws", webSocketController.OpenWebSocket, middlewares.AuthenticationMiddleware())
}
