package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
)

type MessageRouter struct {
}

func (r *MessageRouter) SetupRoutes(e *echo.Echo) {
	messageController := controllers.NewMessageController()

	group := e.Group("/messages")

	group.Use(func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.AuthenticationMiddleware()(next)
	})

	group.POST("/:id/reaction", messageController.CreateReaction)
}
