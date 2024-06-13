package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
	"together/models"
)

type UserRouter struct{}

func (r *UserRouter) SetupRoutes(e *echo.Echo) {
	userController := controllers.NewUserController()

	group := e.Group("/users")
	group.POST("", userController.CreateUser, func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.FeatureEnabledMiddleware(next, models.FSlugRegister)
	})

	group.GET("", userController.GetUsers, middlewares.AuthenticationMiddleware(models.AdminRole))

	group.PUT("/:id", userController.UpdateUser, middlewares.AuthenticationMiddleware())

	group.DELETE("/:id", userController.DeleteUser, middlewares.AuthenticationMiddleware(models.AdminRole))
}
