package controllers

import (
	"github.com/gorilla/websocket"
	"github.com/labstack/echo/v4"
	"together/models"
	"together/services"
)

type WebSocketController struct {
	messageService *services.WebSocketService
}

func NewWebSocketController() *WebSocketController {
	return &WebSocketController{
		messageService: services.NewWebSocketService(),
	}
}

var (
	upgrader = websocket.Upgrader{}
)

func (controller *WebSocketController) OpenWebSocket(ctx echo.Context) error {
	// Get current authenticated user from context
	loggedUser := ctx.Get("user").(models.User)

	ws, err := upgrader.Upgrade(ctx.Response(), ctx.Request(), nil)
	if err != nil {
		return err
	}

	defer controller.messageService.AcceptNewWebSocketConnection(ws, &loggedUser)(ws)

	for {
		_, msg, err := ws.ReadMessage()
		if err != nil {
			ctx.Logger().Error(err)
			break
		}

		if err := controller.messageService.HandleWebSocketMessage(msg, &loggedUser, ws); err != nil {
			ctx.Logger().Warn(err)
			continue
		}
	}
	return nil
}
