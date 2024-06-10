package controllers

import (
	"errors"
	"github.com/go-playground/validator/v10"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/labstack/echo/v4"
	"net/http"
	"together/database"
	"together/models"
	"together/services"
	"together/utils"
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

func (c *EventTypeController) CreateEventType(ctx echo.Context) error {
	var formData models.EventType

	if err := ctx.Bind(&formData); err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	file, err := ctx.FormFile("image")
	if err != nil {
		return ctx.NoContent(http.StatusUnprocessableEntity)
	}
	if !utils.IsImage(*file) {
		return ctx.NoContent(http.StatusUnsupportedMediaType)
	}
	if file.Size > models.MaxFileSize {
		return ctx.NoContent(http.StatusRequestEntityTooLarge)
	}

	newType, err := c.EventTypeService.CreateEventType(formData, *file)
	if err != nil {
		var pgErr *pgconn.PgError
		if errors.As(err, &pgErr) && pgErr.Code == "23505" {
			return ctx.NoContent(http.StatusConflict)
		}

		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, formData)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}

		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusCreated, newType)
}

func (c *EventTypeController) UpdateEventType(ctx echo.Context) error {
	var formData models.EventType

	if err := ctx.Bind(&formData); err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	file, err := ctx.FormFile("image")
	if err != nil {
		return ctx.NoContent(http.StatusUnprocessableEntity)
	}
	if file != nil && !utils.IsImage(*file) {
		return ctx.NoContent(http.StatusUnsupportedMediaType)
	}
	if file.Size > models.MaxFileSize {
		return ctx.NoContent(http.StatusRequestEntityTooLarge)
	}

	var eventTypeToUpdate models.EventType
	err = database.CurrentDatabase.First(&eventTypeToUpdate, ctx.Param("id")).Error
	if err != nil {
		return ctx.NoContent(http.StatusNotFound)
	}

	eventTypeToUpdate.Name = formData.Name
	eventTypeToUpdate.Description = formData.Description

	updatedType, err := c.EventTypeService.UpdateEventType(eventTypeToUpdate, file)
	if err != nil {
		var pgErr *pgconn.PgError
		if errors.As(err, &pgErr) && pgErr.Code == "23505" {
			return ctx.NoContent(http.StatusConflict)
		}

		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, formData)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}

		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, updatedType)
}

func (c *EventTypeController) DeleteEventType(ctx echo.Context) error {
	var eventType models.EventType
	err := database.CurrentDatabase.
		Preload("Events").
		First(&eventType, ctx.Param("id")).Error
	if err != nil {
		return ctx.NoContent(http.StatusNotFound)
	}

	if len(eventType.Events) > 0 {
		return ctx.String(http.StatusForbidden, "Impossible de supprimer un type d'événement avec des événements associés")
	}

	err = c.EventTypeService.DeleteEventType(eventType)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.NoContent(http.StatusNoContent)
}
