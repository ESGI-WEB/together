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

	group.GET("", eventController.GetEvents, middlewares.AuthenticationMiddleware())
	group.POST("", eventController.CreateEvent, middlewares.AuthenticationMiddleware())
	group.GET("/:id", eventController.GetEvent, middlewares.AuthenticationMiddleware())
	group.GET("/:id/attends", eventController.GetEventAttends, middlewares.AuthenticationMiddleware())
	group.GET("/:id/user-event-attend", eventController.GetUserEventAttend, middlewares.AuthenticationMiddleware())
	group.POST("/:id/user-event-attend", eventController.ChangeAttend, middlewares.AuthenticationMiddleware())
}
