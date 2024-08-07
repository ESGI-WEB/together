package controllers

import (
	"encoding/json"
	"errors"
	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
	"net/http"
	"strconv"
	coreErrors "together/errors"
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

	user, ok := ctx.Get("user").(models.User)
	if !ok || user.ID == 0 {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	jsonBody.OwnerID = user.ID
	newGroup, err := c.GroupService.CreateGroup(jsonBody)
	if err != nil {
		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	joinedGroup, err := c.GroupService.JoinGroup(newGroup.Code, user)
	if err != nil {
		switch {
		case errors.Is(err, coreErrors.ErrUserAlreadyInGroup):
			return ctx.String(http.StatusConflict, err.Error())
		case errors.Is(err, coreErrors.ErrCodeDoesNotExist):
			return ctx.String(http.StatusNotFound, err.Error())
		default:
			ctx.Logger().Error(err)
			return ctx.NoContent(http.StatusInternalServerError)
		}
	}

	return ctx.JSON(http.StatusCreated, joinedGroup)
}

func (c *GroupController) GetGroupById(ctx echo.Context) error {
	id := ctx.Param("groupId")
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

	pagination := utils.PaginationFromContext(ctx)

	groups, err := c.GroupService.GetAllMyGroups(user.ID, pagination)
	if err != nil {
		ctx.Logger().Error(err)
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

	group, err := c.GroupService.JoinGroup(jsonBody.Code, user)
	if err != nil {

		if errors.Is(err, coreErrors.ErrUserAlreadyInGroup) {
			return ctx.String(http.StatusConflict, err.Error())
		}
		if errors.Is(err, coreErrors.ErrCodeDoesNotExist) {
			return ctx.String(http.StatusNotFound, err.Error())
		}

		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusCreated, group)
}

func (c *GroupController) GetNextEvent(ctx echo.Context) error {
	id := ctx.Param("groupId")
	groupID, err := strconv.Atoi(id)

	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	event, err := c.GroupService.GetNextEvent(uint(groupID))
	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	if event == nil {
		return ctx.NoContent(http.StatusOK) // nothing found but successfully executed
	}

	return ctx.JSON(http.StatusOK, event)
}

func (c *GroupController) GetAllGroups(ctx echo.Context) error {
	var filters []services.GroupFilter
	// get filters from query params
	params := ctx.QueryParams().Get("filters")
	if len(params) > 0 {
		err := json.Unmarshal([]byte(params), &filters)
		if err != nil {
			return ctx.NoContent(http.StatusBadRequest)
		}
	}

	validate := validator.New(validator.WithRequiredStructEnabled())
	for _, filter := range filters {
		err := validate.Struct(filter)
		if err != nil {
			var validationErrs validator.ValidationErrors
			if errors.As(err, &validationErrs) {
				validationErrors := utils.GetValidationErrors(validationErrs, filter)
				return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
			}
			ctx.Logger().Error(err)
			return ctx.NoContent(http.StatusInternalServerError)
		}
	}

	pagination := utils.PaginationFromContext(ctx)
	groups, err := c.GroupService.GetAllGroups(pagination, filters...)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, groups)
}

func (c *GroupController) GetGroupEvents(ctx echo.Context) error {
	id := ctx.Param("groupId")
	groupID, err := strconv.Atoi(id)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	pagination := utils.PaginationFromContext(ctx)

	events, err := c.GroupService.GetGroupEvents(uint(groupID), pagination)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, events)
}
