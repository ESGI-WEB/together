package controllers

import (
	"github.com/gorilla/websocket"
	"github.com/labstack/echo/v4"
	"together/models"
	"together/services"
)

type MessageController struct {
	messageService *services.MessageService
}

func NewMessageController() *MessageController {
	return &MessageController{
		messageService: services.NewMessageService(),
	}
}

var (
	upgrader = websocket.Upgrader{}
)

func (controller *MessageController) Hello(ctx echo.Context) error {
	// Get current authenticated user from context
	loggedUser := ctx.Get("user").(models.User)

	ws, err := upgrader.Upgrade(ctx.Response(), ctx.Request(), nil)
	if err != nil {
		return err
	}

	defer controller.messageService.AcceptNewConnection(ws)(ws)

	for {
		_, msg, err := ws.ReadMessage()
		if err != nil {
			ctx.Logger().Error(err)
			break
		}

		if err := controller.messageService.HandleMessage(msg, loggedUser); err != nil {
			ctx.Logger().Warn(err)
			continue
		}
	}
	return nil
}
