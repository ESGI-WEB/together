package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
	"together/models"
)

type SecurityRouter struct{}

func (r *SecurityRouter) SetupRoutes(e *echo.Echo) {
	securityController := controllers.NewSecurityController()

	group := e.Group("/security")
	group.POST("/login", securityController.Login, func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.FeatureEnabledMiddleware(next, models.FSlugLogin)
	})
}
