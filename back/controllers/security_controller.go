package controllers

import (
	"encoding/json"
	"errors"
	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
	"net/http"
	coreErrors "together/errors"
	"together/services"
	"together/utils"
)

type SecurityController struct {
	securityService *services.SecurityService
}

func NewSecurityController() *SecurityController {
	return &SecurityController{
		securityService: services.NewSecurityService(),
	}
}

func (c *SecurityController) Login(ctx echo.Context) error {
	var jsonBody struct {
		Email    string `json:"email" validate:"required,email"`
		Password string `json:"password" validate:"required,min=8,max=50"`
	}
	err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	validate := validator.New(validator.WithRequiredStructEnabled())
	err = validate.Struct(jsonBody)
	if err != nil {
		validationErrors := utils.GetValidationErrors(err.(validator.ValidationErrors), jsonBody)
		return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
	}

	result, err := c.securityService.Login(jsonBody.Email, jsonBody.Password)
	if err != nil {
		if errors.Is(err, coreErrors.ErrInvalidCredentials) {
			return ctx.NoContent(http.StatusUnauthorized)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, result)
}
