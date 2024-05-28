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
	group.POST("", eventController.CreateEvent, middlewares.AuthenticationMiddleware)
	group.GET("/:id", eventController.GetEvent, middlewares.AuthenticationMiddleware)

}
