package controllers

import (
	"encoding/json"
	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
	"net/http"
	"strconv"
	"together/models"
	"together/services"
)

type MessageController struct {
	messageService   *services.MessageService
	webSocketService *services.WebSocketService
	groupService     *services.GroupService
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
