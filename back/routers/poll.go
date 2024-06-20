package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
)

type PollRouter struct{}

func (r *PollRouter) SetupRoutes(e *echo.Echo) {
	pollController := controllers.NewPollController()

	group := e.Group("/polls")
	group.POST("", pollController.CreatePoll, middlewares.AuthenticationMiddleware())
	group.GET("/event/:eventId", pollController.GetPollsByEventID, middlewares.AuthenticationMiddleware())
	group.GET("/group/:groupId", pollController.GetPollsByGroupID, middlewares.AuthenticationMiddleware())
	group.PUT("/:pollId", pollController.EditPoll, middlewares.AuthenticationMiddleware())
	group.DELETE("/:pollId", pollController.DeletePoll, middlewares.AuthenticationMiddleware())
	group.POST("/:pollId/choice", pollController.AddChoice, middlewares.AuthenticationMiddleware())
	group.DELETE("/:pollId/choice/:choiceId", pollController.DeleteChoice, middlewares.AuthenticationMiddleware())
	group.POST("/:pollId/choice/:choiceId/select", pollController.SelectChoice, middlewares.AuthenticationMiddleware())
	group.POST("/:pollId/choice/:choiceId/deselect", pollController.DeselectChoice, middlewares.AuthenticationMiddleware())
}
