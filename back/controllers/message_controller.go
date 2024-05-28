package controllers

import (
	"encoding/json"
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
	upgrader    = websocket.Upgrader{}
	connections = make([]*websocket.Conn, 0)
)

func sendMessage(message SentMessage, v *websocket.Conn) {
	bytes, err := json.Marshal(message)
	if err == nil {
		_ = v.WriteMessage(websocket.TextMessage, bytes)
	}
}

func broadcast(message SentMessage) {
	for _, v := range connections {
		sendMessage(message, v)
	}
}

type ReceivedMessage struct {
	Content string `json:"content"`
}

type SentMessage struct {
	Content    string `json:"content"`
	AuthorName string `json:"author_name"`
}

func (controller *MessageController) Hello(ctx echo.Context) error {
	// Get current authenticated user from context
	loggedUser := ctx.Get("user").(models.User)
	ctx.Logger().Debug(loggedUser.Name)

	ws, err := upgrader.Upgrade(ctx.Response(), ctx.Request(), nil)
	if err != nil {
		return err
	}

	defer func(ws *websocket.Conn) {
		_ = ws.Close()

		// Remove the closed web socket from the connection list
		for i, v := range connections {
			if v == ws {
				connections = append(connections[:i], connections[i+1:]...)
				break
			}
		}
	}(ws)

	connections = append(connections, ws)

	response := SentMessage{
		Content:    "Hello, Client!",
		AuthorName: "Server",
	}
	sendMessage(response, ws)

	for {
		_, msg, err := ws.ReadMessage()
		if err != nil {
			ctx.Logger().Error(err)
			break
		}

		// TODO: Parse message to get "groupId"
		var decodedMessage ReceivedMessage
		err = json.Unmarshal(msg, &decodedMessage)
		if err != nil {
			continue
		}

		// TODO: Verify that user has the permission to send a message in the requested group

		// Broadcast message to all connected users in the group
		response := SentMessage{
			Content:    decodedMessage.Content,
			AuthorName: loggedUser.Name,
		}
		broadcast(response) // TODO: Broadcast only to members of the requested group

		// TODO: Save message
		// TODO: Send notification if the recipient is not in the broadcast channel
	}
	return nil
}
