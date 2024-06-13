package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
	"together/models"
)

type AdminRouter struct{}

func (r *AdminRouter) SetupRoutes(e *echo.Echo) {
	userController := controllers.NewUserController()

	group := e.Group("/admin")

	group.POST("/users", userController.CreateUser, middlewares.AuthenticationMiddleware(models.AdminRole))
}
