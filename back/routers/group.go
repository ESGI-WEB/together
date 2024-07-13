package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
	"together/models"
)

type GroupRouter struct{}

func (r *GroupRouter) SetupRoutes(e *echo.Echo) {
	groupController := controllers.NewGroupController()

	group := e.Group("/groups")

	group.GET("", groupController.GetAllMyGroups, middlewares.AuthenticationMiddleware())
	group.GET("/all", groupController.GetAllGroups, middlewares.AuthenticationMiddleware(models.AdminRole))
	group.GET("/:id", groupController.GetGroupById, middlewares.AuthenticationMiddleware(), middlewares.GroupMembershipMiddleware)
	group.POST("", groupController.CreateGroup, middlewares.AuthenticationMiddleware())
	group.POST("/join", groupController.JoinGroup, middlewares.AuthenticationMiddleware())
	group.GET("/:id/next-event", groupController.GetNextEvent, middlewares.AuthenticationMiddleware(), middlewares.GroupMembershipMiddleware)
}
