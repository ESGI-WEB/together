package controllers

import (
	"encoding/json"
	"errors"
	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
	"net/http"
	"strconv"
	"together/models"
	"together/services"
	"together/utils"
)

type EventController struct {
	GroupService   *services.GroupService
	EventService   *services.EventService
	AddressService *services.AddressService
}

func NewEventController() *EventController {
	return &EventController{
		EventService:   services.NewEventService(),
		AddressService: services.NewAddressService(),
	}
}

func (c *EventController) CreateEvent(ctx echo.Context) error {
	var jsonBody models.EventCreate
	err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody)
	if err != nil || jsonBody.GroupID == 0 {
		return ctx.NoContent(http.StatusBadRequest)
	}
	user := ctx.Get("user").(models.User)
	if user.ID == 0 {
		return ctx.NoContent(http.StatusUnauthorized)
	}
	jsonBody.OrganizerID = user.ID

	isUserInGroup, err := c.GroupService.IsUserInGroup(user.ID, jsonBody.GroupID)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}
	if !isUserInGroup {
		return ctx.NoContent(http.StatusUnauthorized)
	}

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

func (c *EventController) GetEvent(ctx echo.Context) error {
	eventIDParam := ctx.Param("id")
	eventID, err := strconv.Atoi(eventIDParam)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	event, err := c.EventService.GetEventByID(uint(eventID))
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	if event == nil {
		return ctx.NoContent(http.StatusNotFound)
	}

	return ctx.JSON(http.StatusOK, event)
}

func (c *EventController) GetEventAttends(ctx echo.Context) error {
	eventIDParam := ctx.Param("id")
	eventID, err := strconv.Atoi(eventIDParam)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	pagination := utils.PaginationFromContext(ctx)
	hasAttendedParam := ctx.QueryParam("has_attended")
	var hasAttended *bool
	if hasAttendedParam != "" {
		hasAttendedBool, err := strconv.ParseBool(hasAttendedParam)
		if err != nil {
			return ctx.NoContent(http.StatusBadRequest)
		}
		hasAttended = &hasAttendedBool
	}

	attends, err := c.EventService.GetEventAttends(uint(eventID), *pagination, hasAttended)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, attends)
}
