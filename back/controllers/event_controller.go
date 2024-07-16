package controllers

import (
	"encoding/json"
	"errors"
	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
	"net/http"
	"strconv"
	"together/database"
	"together/models"
	"together/services"
	"together/utils"
)

type EventController struct {
	GroupService     *services.GroupService
	EventService     *services.EventService
	AddressService   *services.AddressService
	WebsocketService *services.WebSocketService
}

func NewEventController() *EventController {
	return &EventController{
		EventService:     services.NewEventService(),
		AddressService:   services.NewAddressService(),
		GroupService:     services.NewGroupService(),
		WebsocketService: services.NewWebSocketService(),
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
		ctx.Logger().Error(err)
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
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	if newEvent.RecurrenceType != nil {
		_, err := c.EventService.DuplicateEventForYear(newEvent.ID, user.ID)
		if err != nil {
			return ctx.NoContent(http.StatusInternalServerError)
		}
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
		ctx.Logger().Error(err)
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

	attends, err := c.EventService.GetEventAttends(uint(eventID), pagination, hasAttended)
	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, attends)
}

func (c *EventController) GetEvents(ctx echo.Context) error {
	var filters []services.EventFilter

	// get filters from query params
	params := ctx.QueryParams().Get("filters")
	if len(params) > 0 {
		err := json.Unmarshal([]byte(params), &filters)
		if err != nil {
			return ctx.NoContent(http.StatusBadRequest)
		}
	}

	currentUser := ctx.Get("user").(models.User)
	if !currentUser.IsAdmin() {
		// if not admin, only return events that the user is the organizer
		filters = append(filters, services.EventFilter{
			Column: "organizer_id",
			Filter: database.Filter{
				Operator: "=",
				Value:    currentUser.ID,
			},
		})
	}

	validate := validator.New(validator.WithRequiredStructEnabled())
	for _, filter := range filters {
		err := validate.Struct(filter)
		if err != nil {
			var validationErrs validator.ValidationErrors
			if errors.As(err, &validationErrs) {
				validationErrors := utils.GetValidationErrors(validationErrs, filter)
				return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
			}
			ctx.Logger().Error(err)
			return ctx.NoContent(http.StatusInternalServerError)
		}
	}

	pagination := utils.PaginationFromContext(ctx)
	events, err := c.EventService.GetEvents(pagination, filters...)
	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, events)
}

func (c *EventController) DuplicateEvent(ctx echo.Context) error {
	eventIDParam := ctx.Param("id")
	eventID, err := strconv.Atoi(eventIDParam)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	user := ctx.Get("user").(models.User)

	event, err := c.EventService.GetEventByID(uint(eventID))
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	if event == nil {
		return ctx.NoContent(http.StatusNotFound)
	}

	if event.ID == 0 {
		return ctx.NoContent(http.StatusNotFound)
	}

	if !user.IsAdmin() && event.OrganizerID != user.ID {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	var jsonBody services.DuplicateEventRequest
	err = json.NewDecoder(ctx.Request().Body).Decode(&jsonBody)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	duplicatedEvent, err := c.EventService.DuplicateEvent(uint(eventID), jsonBody.NewDate, user.ID)
	if err != nil {
		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusCreated, duplicatedEvent)
}

func (c *EventController) DuplicateEventForYear(ctx echo.Context) error {
	eventIDParam := ctx.Param("id")
	eventID, err := strconv.Atoi(eventIDParam)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	user := ctx.Get("user").(models.User)

	event, err := c.EventService.GetEventByID(uint(eventID))
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	if event == nil {
		return ctx.NoContent(http.StatusNotFound)
	}

	if event.ID == 0 {
		return ctx.NoContent(http.StatusNotFound)
	}

	if !user.IsAdmin() && event.OrganizerID != user.ID {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	duplicatedEvents, err := c.EventService.DuplicateEventForYear(uint(eventID), user.ID)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusCreated, duplicatedEvents)
}

func (c *EventController) DuplicateEventsForTomorrow(ctx echo.Context) error {
	err := c.EventService.DuplicateEventsForTomorrow()
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}
	return ctx.NoContent(http.StatusCreated)
}

func (c *EventController) GetUserEventAttend(ctx echo.Context) error {
	user := ctx.Get("user").(models.User)

	eventIDParam := ctx.Param("id")
	eventID, err := strconv.Atoi(eventIDParam)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	event, err := c.EventService.GetEventByID(uint(eventID))
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	if event == nil || event.ID == 0 {
		return ctx.NoContent(http.StatusNotFound)
	}

	attend := c.EventService.GetUserEventAttend(uint(eventID), user.ID)
	return ctx.JSON(http.StatusOK, attend)
}

func (c *EventController) ChangeAttend(ctx echo.Context) error {
	user := ctx.Get("user").(models.User)

	eventIDParam := ctx.Param("id")
	eventIDInt, err := strconv.Atoi(eventIDParam)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}
	eventID := uint(eventIDInt)

	event, err := c.EventService.GetEventByID(eventID)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}
	if event == nil || event.ID == 0 {
		return ctx.NoContent(http.StatusNotFound)
	}

	body := struct {
		IsAttending bool `json:"is_attending"`
	}{}
	err = json.NewDecoder(ctx.Request().Body).Decode(&body)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}
	isAttending := body.IsAttending

	attend, err := c.EventService.ChangeUserEventAttend(isAttending, eventID, user.ID)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	c.notifyUsersOfAttendsChanged(user.ID, eventID)

	return ctx.JSON(http.StatusOK, attend)
}

func (c *EventController) notifyUsersOfAttendsChanged(userID uint, eventID uint) {
	attend := c.EventService.GetUserEventAttend(eventID, userID, "User", "Event")
	if attend == nil {
		return
	}

	pollWsMessage := services.ServerBoundGroupBroadcast{
		TypeMessage: services.TypeMessage{
			Type: services.ServerBoundEventAttendChangedMessageType,
		},
		Content: attend,
	}

	bytes, err := json.Marshal(pollWsMessage)
	if err != nil {
		return
	}

	err = c.WebsocketService.BroadcastToGroup(bytes, attend.Event.GroupID)
	if err != nil {
		return
	}

	return
}
