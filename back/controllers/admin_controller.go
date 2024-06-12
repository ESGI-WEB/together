package controllers

import "github.com/labstack/echo/v4"

type AdminController struct{}

func NewAdminController() *AdminController {
	return &AdminController{}
}

func (c *AdminController) GetLastYearRegistrationsCount(ctx echo.Context) error {
	return ctx.JSON(200, "Last year registrations")
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
