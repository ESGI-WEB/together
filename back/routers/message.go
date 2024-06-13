package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
)

type MessageRouter struct{}

func (r *MessageRouter) SetupRoutes(e *echo.Echo) {
	messageController := controllers.NewMessageController()

	messages := e.Group("/messages")

	messages.Use(func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.AuthenticationMiddleware()(next)
	})

	messages.POST("/publication", messageController.CreatePublication)
	messages.PUT("/:id", messageController.UpdateMessage)
	messages.DELETE("/:id", messageController.DeleteMessage)
	messages.POST("/:id/pin", messageController.PinMessage)
	messages.GET("group/:groupId/event/:eventId", messageController.GetPublicationsByEventAndGroup, middlewares.GroupMembershipMiddleware)
	messages.GET("/group/:groupId", messageController.GetPublicationsByGroup, middlewares.GroupMembershipMiddleware)
}
