package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
)

type EventTypeRouter struct{}

func (r *EventTypeRouter) SetupRoutes(e *echo.Echo) {
	eventTypeController := controllers.NewEventTypeController()

	group := e.Group("/event-types")

	group.Use(func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.AuthenticationMiddleware()(next)
	})

	group.GET("", eventTypeController.GetAllEventTypes)
}
