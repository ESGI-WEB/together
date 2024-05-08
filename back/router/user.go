package router

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
)

type UserRouter struct{}

func (r *UserRouter) SetupRoutes(e *echo.Echo) {
	userController := controllers.NewUserController()

	group := e.Group("/users")
	group.POST("", userController.CreateUser)
}
