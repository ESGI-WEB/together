package controllers

import (
	"encoding/json"
	"errors"
	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
	"net/http"
	coreErrors "together/errors"
	"together/models"
	"together/services"
	"together/utils"
)

type UserController struct {
	UserService *services.UserService
}

func NewUserController() *UserController {
	return &UserController{
		UserService: services.NewUserService(),
	}
}

func (c *UserController) CreateUser(ctx echo.Context) error {
	var jsonBody models.UserCreate
	err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	newUser, err := c.UserService.AddUser(jsonBody)
	if err != nil {
		if errors.Is(err, coreErrors.ErrUserAlreadyExists) {
			return ctx.String(http.StatusConflict, err.Error())
		}

		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}

		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusCreated, newUser)
}
