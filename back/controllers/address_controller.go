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

type AddressController struct {
	AddressService *services.AddressService
}

func NewAddressController() *AddressController {
	return &AddressController{
		AddressService: services.NewAddressService(),
	}
}

func (c *AddressController) CreateAddress(ctx echo.Context) error {
	var jsonBody models.AddressCreate
	err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}
	newAddress, err := c.AddressService.AddAddress(jsonBody)
	if err != nil {
		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusCreated, newAddress)
}
