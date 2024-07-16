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
	adminController := controllers.NewAdminController()

	group := e.Group("/admin")

	group.POST("/users", userController.CreateUser, middlewares.AuthenticationMiddleware(models.AdminRole))

	stats := group.Group("/stats")
	stats.GET("/monthly-last-year-registration-count", adminController.GetMonthlyLastYearRegistrationsCount, middlewares.AuthenticationMiddleware(models.AdminRole))
	stats.GET("/monthly-messages-count", adminController.GetMonthlyMessagesCount, middlewares.AuthenticationMiddleware(models.AdminRole))
	stats.GET("/event-types-count", adminController.GetEventTypesCount, middlewares.AuthenticationMiddleware(models.AdminRole))
}
