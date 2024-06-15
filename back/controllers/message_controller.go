package controllers

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/go-playground/validator/v10"
	"github.com/gorilla/websocket"
	"github.com/labstack/echo/v4"
	"net/http"
	"strconv"
	"together/database"
	"together/models"
	"together/services"
	"together/utils"
)

type MessageController struct {
	messageService *services.MessageService
	groupService   *services.GroupService
}

func NewMessageController() *MessageController {
	return &MessageController{
		messageService: services.NewMessageService(),
	}
}

var (
	upgrader = websocket.Upgrader{}
)

func (c *MessageController) Hello(ctx echo.Context) error {
	// Get current authenticated user from context
	loggedUser := ctx.Get("user").(models.User)

	ws, err := upgrader.Upgrade(ctx.Response(), ctx.Request(), nil)
	if err != nil {
		return err
	}

	defer c.messageService.AcceptNewConnection(ws)(ws)

	for {
		_, msg, err := ws.ReadMessage()
		if err != nil {
			ctx.Logger().Error(err)
			break
		}

		if err := c.messageService.HandleMessage(msg, loggedUser); err != nil {
			ctx.Logger().Warn(err)
			continue
		}
	}
	return nil
}

func (c *MessageController) CreatePublication(ctx echo.Context) error {
	var jsonBody models.MessageCreate

	if err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody); err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	user, ok := ctx.Get("user").(models.User)
	if !ok || user.ID == 0 {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	isUserInGroup, err := c.groupService.IsUserInGroup(user.ID, jsonBody.GroupID)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}
	if !isUserInGroup {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	jsonBody.UserID = user.ID

	newMessage, err := c.messageService.CreatePublication(jsonBody)
	if err != nil {
		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusCreated, newMessage)
}

func (c *MessageController) UpdateMessage(ctx echo.Context) error {
	id := ctx.Param("id")
	messageID, err := strconv.Atoi(id)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	var jsonBody models.MessageUpdate
	if err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody); err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	user, ok := ctx.Get("user").(models.User)
	if !ok || user.ID == 0 {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	var message models.Message
	if err := database.CurrentDatabase.First(&message, messageID).Error; err != nil {
		return ctx.NoContent(http.StatusNotFound)
	}

	isUserInGroup, err := c.groupService.IsUserInGroup(user.ID, message.GroupID)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}
	if !isUserInGroup {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	updatedMessage, err := c.messageService.UpdateContent(uint(messageID), jsonBody)
	fmt.Println("erroe encore", err)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, updatedMessage)
}

func (c *MessageController) PinMessage(ctx echo.Context) error {
	id := ctx.Param("id")
	messageID, err := strconv.Atoi(id)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	var jsonBody models.MessagePinned
	if err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody); err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	user, ok := ctx.Get("user").(models.User)
	if !ok || user.ID == 0 {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	var message models.Message
	if err := database.CurrentDatabase.First(&message, messageID).Error; err != nil {
		return ctx.NoContent(http.StatusNotFound)
	}

	pinnedMessage, err := c.messageService.PinnedMessage(uint(messageID), jsonBody)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, pinnedMessage)
}

func (c *MessageController) DeleteMessage(ctx echo.Context) error {
	id := ctx.Param("id")
	messageID, err := strconv.Atoi(id)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	user, ok := ctx.Get("user").(models.User)
	if !ok || user.ID == 0 {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	var message models.Message
	if err := database.CurrentDatabase.First(&message, messageID).Error; err != nil {
		return ctx.NoContent(http.StatusNotFound)
	}

	if err := c.messageService.DeleteMessage(uint(messageID)); err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.NoContent(http.StatusNoContent)
}

func (c *MessageController) GetPublicationsByEventAndGroup(ctx echo.Context) error {
	eventIDStr := ctx.Param("eventId")
	groupIDStr := ctx.Param("groupId")

	eventID, err := strconv.Atoi(eventIDStr)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	groupID, err := strconv.Atoi(groupIDStr)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	user, ok := ctx.Get("user").(models.User)
	if !ok || user.ID == 0 {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	messages, err := c.messageService.GetPublicationsByEventAndGroup(uint(eventID), uint(groupID))
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, messages)
}

func (c *MessageController) GetPublicationsByGroup(ctx echo.Context) error {
	groupIDStr := ctx.Param("groupId")
	groupID, err := strconv.Atoi(groupIDStr)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	user, ok := ctx.Get("user").(models.User)
	if !ok || user.ID == 0 {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	messages, err := c.messageService.GetPublicationsByGroup(uint(groupID))
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, messages)
}
