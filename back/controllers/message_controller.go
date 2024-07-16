package controllers

import (
	"encoding/json"
	"errors"
	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
	"net/http"
	"strconv"
	"together/database"
	"together/models"
	"together/services"
	"together/utils"
)

type MessageController struct {
	webSocketService *services.WebSocketService
	groupService     *services.GroupService
	messageService *services.MessageService
}

func NewMessageController() *MessageController {
	return &MessageController{
		messageService:   services.NewMessageService(),
		webSocketService: services.NewWebSocketService(),
		groupService:     services.NewGroupService(),
	}
}

func (c *MessageController) CreateReaction(ctx echo.Context) error {
	user, ok := ctx.Get("user").(models.User)
	if !ok || user.ID == 0 {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	// Decode and validate the request's body
	var jsonBody models.CreateMessageReaction
	if err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody); err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusBadRequest)
	}
	validate := validator.New(validator.WithRequiredStructEnabled())
	err := validate.Struct(jsonBody)
	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusBadRequest)
	}

	id := ctx.Param("id")
	messageID, err := strconv.Atoi(id)
	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusBadRequest)
	}

	// Check if the user is actually in the message's group
	message, err := c.messageService.GetMessage(uint(messageID))
	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError) // This should maybe be a "not found"?
	}
	isUserInGroup, err := c.groupService.IsUserInGroup(user.ID, message.GroupID)
	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}
	if !isUserInGroup {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusUnauthorized)
	}

	// Create the message's reaction
	reaction, err := c.messageService.ReactToMessage(uint(messageID), jsonBody.ReactionContent, user)

	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusBadRequest)
	}

	// Broadcast the updated message to all the connected clients
	err = c.webSocketService.BroadcastMessageToGroupID(uint(messageID))
	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, reaction)
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

	pagination := utils.PaginationFromContext(ctx)

	messages, err := c.messageService.GetPublicationsByEventAndGroup(uint(eventID), uint(groupID), pagination)
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

	pagination := utils.PaginationFromContext(ctx)

	messages, err := c.messageService.GetPublicationsByGroup(uint(groupID), pagination)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, messages)
}
