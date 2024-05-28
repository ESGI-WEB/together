package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
	"together/models"
)

type FeatureRouter struct{}

func (r *FeatureRouter) SetupRoutes(e *echo.Echo) {
	featureController := controllers.NewFeatureController()

	group := e.Group("/features")

	group.GET("", featureController.List, func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.AuthenticationMiddleware(next, models.AdminRole)
	})
	group.GET("/:slug", featureController.View)
	group.PATCH("/:slug", featureController.Edit, func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.AuthenticationMiddleware(next, models.AdminRole)
	})
}
