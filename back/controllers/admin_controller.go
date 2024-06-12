package controllers

import (
	"github.com/labstack/echo/v4"
	"net/http"
	"together/services"
)

type AdminController struct {
	StatsService *services.StatsService
}

func NewAdminController() *AdminController {
	return &AdminController{
		StatsService: services.NewStatsService(),
	}
}

func (c *AdminController) GetLastYearRegistrationsCount(ctx echo.Context) error {
	stats, err := c.StatsService.GetLastYearRegistrationsCount()
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(200, stats)
}

func (c *AdminController) GetLastDayMessagesCount(ctx echo.Context) error {
	return ctx.JSON(200, "Last day messages")
}

func (c *AdminController) GetNextEvents(ctx echo.Context) error {
	return ctx.JSON(200, "Next events")
}

func (c *AdminController) GetLastYearEventTypesCount(ctx echo.Context) error {
	return ctx.JSON(200, "Last year event types")
}

func (c *AdminController) GetLastCreatedGroups(ctx echo.Context) error {
	return ctx.JSON(200, "Last created groups")
}
