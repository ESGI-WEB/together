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
	group.GET("", groupController.GetAllGroups, middlewares.AuthenticationMiddleware)
	group.GET("/:id", groupController.GetGroupById, middlewares.AuthenticationMiddleware)
	group.POST("", groupController.CreateGroup, middlewares.AuthenticationMiddleware)
	group.POST("/join", groupController.JoinGroup, middlewares.AuthenticationMiddleware)
}
