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

type UserController struct {
	UserService *services.UserService
}

func NewUserController() *UserController {
	return &UserController{
		UserService: services.NewUserService(),
	}
}

func (c *UserController) CreateUser(ctx echo.Context) error {
	var jsonBody models.User
	err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	currentUser := ctx.Get("user")
	if currentUser == nil || (currentUser.(models.User).Role != models.AdminRole) {
		jsonBody.Role = models.UserRole
	}

	newUser, err := c.UserService.AddUser(jsonBody)
	if err != nil {
		if errors.Is(err, coreErrors.ErrUserAlreadyExists) {
			return ctx.String(http.StatusConflict, err.Error())
		}

		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}

		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusCreated, newUser)
}

func (c *UserController) GetUsers(ctx echo.Context) error {
	pagination := utils.PaginationFromContext(ctx)
	search := ctx.QueryParam("search")

	usersPagination, err := c.UserService.GetUsers(pagination, &search)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, usersPagination)
}

func (c *UserController) DeleteUser(ctx echo.Context) error {
	idInt, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	id := uint(idInt)
	if id == ctx.Get("user").(models.User).ID {
		return ctx.String(http.StatusForbidden, "Impossible de supprimer votre propre compte administrateur.")
	}

	err = c.UserService.DeleteUser(id)
	if err != nil {
		if errors.Is(err, coreErrors.ErrNotFound) {
			return ctx.NoContent(http.StatusNotFound)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.NoContent(http.StatusNoContent)
}

func (c *UserController) UpdateUser(ctx echo.Context) error {
	idInt, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	// check id is current user id or admin
	id := uint(idInt)
	currentUser := ctx.Get("user").(models.User)
	if currentUser.ID != id && !currentUser.IsAdmin() {
		return ctx.NoContent(http.StatusForbidden)
	}

	// find user to update
	userToUpdate, err := c.UserService.FindByID(id)
	if err != nil {
		return ctx.NoContent(http.StatusNotFound)
	}

	// decode request body
	var jsonBody models.User
	err = json.NewDecoder(ctx.Request().Body).Decode(&jsonBody)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	// update user fields if they are not empty
	if jsonBody.Name != "" {
		userToUpdate.Name = jsonBody.Name
	}
	if jsonBody.Email != "" {
		userToUpdate.Email = jsonBody.Email
	}
	// if biography is "" then it should be updated, but if null then it should not be updated
	if jsonBody.Biography != nil {
		userToUpdate.Biography = jsonBody.Biography
	}
	if jsonBody.ColorHex != "" {
		userToUpdate.ColorHex = jsonBody.ColorHex
	}
	if jsonBody.PlainPassword != nil {
		userToUpdate.PlainPassword = jsonBody.PlainPassword
	}

	// role is editable if current user is admin and updating another user
	if currentUser.IsAdmin() && currentUser.ID != id {
		userToUpdate.Role = jsonBody.Role
	} else if jsonBody.Role != "" && jsonBody.Role != userToUpdate.Role {
		return ctx.String(http.StatusForbidden, "Impossible de modifier votre rôle.")
	}

	updatedUser, err := c.UserService.UpdateUser(id, *userToUpdate)
	if err != nil {
		if errors.Is(err, coreErrors.ErrNotFound) {
			return ctx.NoContent(http.StatusNotFound)
		}

		if errors.Is(err, coreErrors.ErrUserAlreadyExists) {
			return ctx.NoContent(http.StatusConflict)
		}

		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}

		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, updatedUser)
}

func (c *UserController) FindByID(ctx echo.Context) error {
	idInt, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	id := uint(idInt)
	user, err := c.UserService.FindByID(id)
	if err != nil {
		if errors.Is(err, coreErrors.ErrNotFound) {
			return ctx.NoContent(http.StatusNotFound)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, user)
}
