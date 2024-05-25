package controllers

import (
	"encoding/json"
	"errors"
	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
	"net/http"
	"together/models"
	"together/services"
	"together/utils"
)

type EventController struct {
	EventService *services.EventService
}

func NewEventController() *EventController {
	return &EventController{
		EventService: services.NewEventService(),
	}
}

func (c *EventController) CreateEvent(ctx echo.Context) error {
	var jsonBody models.EventCreate
	err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}
	user := ctx.Get("user").(models.User)
	if user.ID == 0 {
		return ctx.NoContent(http.StatusUnauthorized)
	}
	jsonBody.OrganizerID = ctx.Get("user").(models.User).ID
	newEvent, err := c.EventService.AddEvent(jsonBody)
	if err != nil {
		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusCreated, newEvent)
}
