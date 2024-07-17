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

func (c *AdminController) GetMonthlyLastYearRegistrationsCount(ctx echo.Context) error {
	stats, err := c.StatsService.GetMonthlyLastYearRegistrationsCount()
	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(200, stats)
}

func (c *AdminController) GetMonthlyMessagesCount(ctx echo.Context) error {
	stats, err := c.StatsService.GetMonthlyMessagesCount()
	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(200, stats)
}

func (c *AdminController) GetEventTypesCount(ctx echo.Context) error {
	stats, err := c.StatsService.GetEventTypesCount()
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(200, stats)
}
