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
	var jsonBody models.Group
	if err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody); err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	newGroup, err := c.GroupService.CreateGroup(jsonBody)
	if err != nil {
		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	user, ok := ctx.Get("user").(models.User)
	if !ok || user.ID == 0 {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	joinRequest := models.JoinGroupRequest{Code: jsonBody.Code, UserId: user.ID}
	if err := c.GroupService.JoinGroup(joinRequest); err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusCreated, newGroup)
}

func (c *GroupController) GetGroupById(ctx echo.Context) error {
	id := ctx.Param("id")
	groupID, err := strconv.Atoi(id)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	group, err := c.GroupService.GetGroupById(uint(groupID))
	if err != nil {
		return ctx.NoContent(http.StatusNotFound)
	}

	return ctx.JSON(http.StatusOK, group)
}

func (c *GroupController) GetAllMyGroups(ctx echo.Context) error {
	user, ok := ctx.Get("user").(models.User)
	if !ok || user.ID == 0 {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	groups, err := c.GroupService.GetAllMyGroups(user.ID)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, groups)
}

func (c *GroupController) JoinGroup(ctx echo.Context) error {
	var jsonBody models.JoinGroupRequest

	if err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody); err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	user, ok := ctx.Get("user").(models.User)
	if !ok || user.ID == 0 {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	jsonBody.UserId = user.ID
	if err := c.GroupService.JoinGroup(jsonBody); err != nil {
		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.NoContent(http.StatusOK)
}
