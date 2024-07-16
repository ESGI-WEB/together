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

	group.GET("", featureController.List, middlewares.AuthenticationMiddleware(models.AdminRole))
	group.GET("/:slug", featureController.View)
	group.PATCH("/:slug", featureController.Edit, middlewares.AuthenticationMiddleware(models.AdminRole))
}
