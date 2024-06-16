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

	group.Use(func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.AuthenticationMiddleware()(next)
	})

	group.GET("", groupController.GetAllMyGroups)
	group.GET("/:groupId", groupController.GetGroupById, middlewares.GroupMembershipMiddleware)
	group.POST("", groupController.CreateGroup)
	group.POST("/join", groupController.JoinGroup)
	group.GET("/:groupId/next-event", groupController.GetNextEvent, middlewares.GroupMembershipMiddleware)
}
