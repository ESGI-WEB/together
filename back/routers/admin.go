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
	stats.GET("/last-year-registrations-count", adminController.GetLastYearRegistrationsCount, middlewares.AuthenticationMiddleware(models.AdminRole))
	stats.GET("/last-day-messages-count", adminController.GetLastDayMessagesCount, middlewares.AuthenticationMiddleware(models.AdminRole))
	stats.GET("/next-events", adminController.GetNextEvents, middlewares.AuthenticationMiddleware(models.AdminRole))
	stats.GET("/last-year-event-types-count", adminController.GetLastYearEventTypesCount, middlewares.AuthenticationMiddleware(models.AdminRole))
	stats.GET("/last-created-groups", adminController.GetLastCreatedGroups, middlewares.AuthenticationMiddleware(models.AdminRole))
}
