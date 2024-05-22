package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
)

type GroupRouter struct{}

func (r *GroupRouter) SetupRoutes(e *echo.Echo) {
	groupController := controllers.NewGroupController()

	group := e.Group("/groups")
	group.GET("", groupController.GetAllGroups)
	group.GET("/:id", groupController.GetGroupById)
	group.POST("", groupController.CreateGroup)
	group.POST("/join", groupController.JoinGroup)
}
