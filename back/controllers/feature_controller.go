package controllers

import (
	"encoding/json"
	"errors"
	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
	"net/http"
	"together/database"
	"together/models"
	"together/services"
	"together/utils"
)

type FeatureController struct {
	featureService *services.FeatureFlippingService
}

func NewFeatureController() *FeatureController {
	return &FeatureController{
		featureService: services.NewFeatureFlippingService(),
	}
}

func (c *FeatureController) List(ctx echo.Context) error {
	return ctx.JSON(http.StatusOK, c.featureService.List())
}

func (c *FeatureController) View(ctx echo.Context) error {
	feature := c.featureService.GetBySlug(models.FeatureSlug(ctx.Param("slug")))
	if feature != nil {
		return ctx.JSON(http.StatusOK, feature)
	}
	return ctx.NoContent(http.StatusNotFound)
}

func (c *FeatureController) Edit(ctx echo.Context) error {
	var jsonBody models.EditFeatureFlipping
	err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	var feature models.FeatureFlipping
	database.CurrentDatabase.Where("slug = ?", ctx.Param("slug")).First(&feature)
	if feature.Slug == "" {
		return ctx.NoContent(http.StatusNotFound)
	}

	editedFeature, err := c.featureService.Edit(&feature, jsonBody)

	if err != nil {
		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}

		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, editedFeature)
}
