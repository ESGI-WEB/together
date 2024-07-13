package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
	"together/models"
)

type EventRouter struct{}

func (r *EventRouter) SetupRoutes(e *echo.Echo) {
	eventController := controllers.NewEventController()

	group := e.Group("/events")

	group.GET("", eventController.GetEvents, middlewares.AuthenticationMiddleware())
	group.POST("", eventController.CreateEvent, middlewares.AuthenticationMiddleware())
	group.GET("/:id", eventController.GetEvent, middlewares.AuthenticationMiddleware())
	group.GET("/:id/attends", eventController.GetEventAttends, middlewares.AuthenticationMiddleware())
	group.POST("/:id/duplicate", eventController.DuplicateEvent, middlewares.AuthenticationMiddleware())
	group.POST("/:id/duplicate/year", eventController.DuplicateEventForYear, middlewares.AuthenticationMiddleware())
	group.POST("/duplicate-tomorrow", eventController.DuplicateEventsForTomorrow, middlewares.AuthenticationMiddleware(models.AdminRole))

}
