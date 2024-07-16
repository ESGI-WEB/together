package controllers

import (
	"encoding/json"
	"github.com/labstack/echo/v4"
	"net/http"
	"strconv"
	"together/models"
	"together/services"
)

type MessageController struct {
	messageService   *services.MessageService
	webSocketService *services.WebSocketService
	messageService *services.MessageService
	groupService   *services.GroupService
}

func NewMessageController() *MessageController {
	return &MessageController{
		messageService:   services.NewMessageService(),
		webSocketService: services.NewWebSocketService(),
	}
}

func (c *MessageController) CreateReaction(ctx echo.Context) error {
	user, ok := ctx.Get("user").(models.User)
	if !ok || user.ID == 0 {
		return ctx.NoContent(http.StatusUnauthorized)
	}

	id := ctx.Param("id")
	messageID, err := strconv.Atoi(id)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	var jsonBody models.CreateMessageReaction

	if err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody); err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	reaction, err := c.messageService.ReactToMessage(messageID, jsonBody.ReactionContent, user.ID)

	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	// TODO: Broadcast to every all the group's members
	// TODO: Use correct websocket event type
	response := services.ServerBoundSendChatMessage{
		TypeMessage: services.TypeMessage{
			Type: services.ServerBoundSendChatMessageType,
		},
		Content: reaction.Message.Content,
		Author:  &reaction.Message.User,
		GroupId: reaction.Message.GroupID,
	}

	bytes, err := json.Marshal(response)
	if err != nil {
		return err
	}

	if err := c.webSocketService.BroadcastToGroup(bytes, reaction.Message.GroupID); err != nil {
		return err
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
