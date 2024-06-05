package controllers

import (
	"github.com/labstack/echo/v4"
	"net/http"
	"together/services"
)

type EventTypeController struct {
	EventTypeService *services.EventTypeService
}

func NewEventTypeController() *EventTypeController {
	return &EventTypeController{
		EventTypeService: services.NewEventTypeService(),
	}
}

func (c *EventTypeController) GetAllEventTypes(ctx echo.Context) error {
	eventTypes, err := c.EventTypeService.GetAllEventTypes()
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}
	return ctx.JSON(http.StatusOK, eventTypes)
}
