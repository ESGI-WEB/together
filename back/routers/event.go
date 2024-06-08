package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
)

type EventRouter struct{}

func (r *EventRouter) SetupRoutes(e *echo.Echo) {
	eventController := controllers.NewEventController()

	group := e.Group("/events")

	group.Use(func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.AuthenticationMiddleware()(next)
	})

	group.POST("", eventController.CreateEvent)
	group.GET("/:id", eventController.GetEvent)
	group.GET("/:id/attends", eventController.GetEventAttends)
}
