package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
	"together/models"
)

type EventTypeRouter struct{}

func (r *EventTypeRouter) SetupRoutes(e *echo.Echo) {
	eventTypeController := controllers.NewEventTypeController()

	group := e.Group("/event-types")
	group.GET("", eventTypeController.GetAllEventTypes, middlewares.AuthenticationMiddleware())
	group.POST("", eventTypeController.CreateEventType, middlewares.AuthenticationMiddleware(models.AdminRole))
	group.PUT("/:id", eventTypeController.UpdateEventType, middlewares.AuthenticationMiddleware(models.AdminRole))
	group.DELETE("/:id", eventTypeController.DeleteEventType, middlewares.AuthenticationMiddleware(models.AdminRole))
}
