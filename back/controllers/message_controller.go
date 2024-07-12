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
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusBadRequest)
	}

	var jsonBody models.CreateMessageReaction

	if err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody); err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusBadRequest)
	}

	reaction, err := c.messageService.ReactToMessage(messageID, jsonBody.ReactionContent, user)

	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusBadRequest)
	}

	// TODO: Broadcast to every all the group's members
	// TODO: Use correct websocket event type
	response := services.ServerBoundSendChatMessage{
		TypeMessage: services.TypeMessage{
			Type: services.ServerBoundSendChatMessageType,
		},
		Content:   reaction.Message.Content,
		Author:    &reaction.Message.User,
		GroupId:   reaction.Message.GroupID,
		Reactions: make([]string, 0),
	}

	bytes, err := json.Marshal(response)
	if err != nil {
		ctx.Logger().Error(err)
		return err
	}

	if err := c.webSocketService.BroadcastToGroup(bytes, reaction.Message.GroupID); err != nil {
		ctx.Logger().Error(err)
		return err
	}

	return ctx.JSON(http.StatusOK, reaction)
}
