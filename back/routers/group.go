package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
)

type GroupRouter struct{}

func (r *GroupRouter) SetupRoutes(e *echo.Echo) {
	groupController := controllers.NewGroupController()

	group := e.Group("/groups")
	group.GET("", groupController.GetAllMyGroups, func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.AuthenticationMiddleware(next)
	})
	group.GET("/:id", groupController.GetGroupById, func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.AuthenticationMiddleware(next)
	})
	group.POST("", groupController.CreateGroup, func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.AuthenticationMiddleware(next)
	})
	group.POST("/join", groupController.JoinGroup, func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.AuthenticationMiddleware(next)
	})
}
