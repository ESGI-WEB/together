package controllers

import (
	"encoding/json"
	"errors"
	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
	"net/http"
	"strconv"
	"together/models"
	"together/services"
	"together/utils"
)

type GroupController struct {
	GroupService *services.GroupService
}

func NewGroupController() *GroupController {
	return &GroupController{
		GroupService: services.NewGroupService(),
	}
}

func (c *GroupController) CreateGroup(ctx echo.Context) error {
	var jsonBody models.GroupCreate
	err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	newGroup, err := c.GroupService.AddGroup(jsonBody)
	if err != nil {
		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}

		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusCreated, newGroup)
}

func (c *GroupController) GetGroup(ctx echo.Context) error {
	id := ctx.Param("id")
	groupID, err := strconv.Atoi(id)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	group, err := c.GroupService.GetGroupByID(uint(groupID))
	if err != nil {
		return ctx.NoContent(http.StatusNotFound)
	}

	return ctx.JSON(http.StatusOK, group)
}

func (c *GroupController) GetAllGroups(ctx echo.Context) error {
	groups, err := c.GroupService.GetAllGroups()
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, groups)
}
