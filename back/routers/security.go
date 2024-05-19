package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
)

type SecurityRouter struct{}

func (r *SecurityRouter) SetupRoutes(e *echo.Echo) {
	securityController := controllers.NewSecurityController()

	group := e.Group("/security")
	group.POST("/login", securityController.Login)
}
