package middlewares

import (
	"github.com/labstack/echo/v4"
	"together/models"
	"together/services"
)

var FeatureEnabledMiddleware = func(next echo.HandlerFunc, slug models.FeatureSlug) echo.HandlerFunc {
	return func(c echo.Context) error {
		featureFlippingService := services.NewFeatureFlippingService()
		if !featureFlippingService.IsFeatureEnabled(slug) {
			return c.JSON(503, map[string]string{"error": "Feature is under maintenance. Please try again later."})
		}

		return next(c)
	}
}
