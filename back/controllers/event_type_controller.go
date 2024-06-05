package controllers

import (
	"errors"
	"github.com/go-playground/validator/v10"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/labstack/echo/v4"
	"net/http"
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

	// Bind form data to the struct
	if err := ctx.Bind(&formData); err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	// check image upload
	file, err := ctx.FormFile("image")
	if err != nil {
		return ctx.NoContent(http.StatusUnprocessableEntity)
	}
	if !utils.IsImage(file.Filename) {
		return ctx.NoContent(http.StatusUnsupportedMediaType)
	}
	const maxFileSize = 10 * 1024 * 1024 // 10MB
	if file.Size > maxFileSize {
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
