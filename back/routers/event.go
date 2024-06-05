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
	group.POST("", eventController.CreateEvent, func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.AuthenticationMiddleware(next)
	})
	group.GET("/:id", eventController.GetEvent, func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.AuthenticationMiddleware(next)
	})
	group.GET("/:id/attends", eventController.GetEventAttends, func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.AuthenticationMiddleware(next)
	})
}
