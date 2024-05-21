package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
)

type GroupRouter struct{}

func (r *GroupRouter) SetupRoutes(e *echo.Echo) {
	groupController := controllers.NewGroupController()

	group := e.Group("/groups")
	group.POST("", groupController.CreateGroup)
	group.GET("/:id", groupController.GetGroup)
	group.GET("", groupController.GetAllGroups)
}
