package services

import (
	"encoding/json"
	"github.com/gorilla/websocket"
	"together/models"
)

type WebSocketService struct {
	connections    []*websocket.Conn
	messageService *MessageService
}

func NewWebSocketService() *WebSocketService {
	return &WebSocketService{
		connections:    make([]*websocket.Conn, 0),
		messageService: NewMessageService(),
	}
}

func (s *WebSocketService) AcceptNewWebSocketConnection(ws *websocket.Conn) func(ws *websocket.Conn) {
	s.connections = append(s.connections, ws)

	return func(ws *websocket.Conn) {
		_ = ws.Close()

		// Remove the closed web socket from the connection list
		for index, connection := range s.connections {
			if connection == ws {
				s.connections = append(s.connections[:index], s.connections[index+1:]...)
				break
			}
		}
	}
}

func (s *WebSocketService) HandleWebSocketMessage(msg []byte, user models.User) error {
	var decodedMessage TypeMessage
	if err := json.Unmarshal(msg, &decodedMessage); err != nil {
		return err
	}
	switch decodedMessage.Type {
	case ClientBoundSendChatMessageType:
		if err := s.messageService.handleSendChatMessage(s, msg, user); err != nil {
			return err
		}
	}
	return nil
}

func (s *WebSocketService) SendWebSocketMessage(data []byte, v *websocket.Conn) error {
	err := v.WriteMessage(websocket.TextMessage, data)

	if err != nil {
		return err
	}
	return nil
}

func (s *WebSocketService) BroadcastWebSocketMessage(data []byte) error {
	for _, v := range s.connections {
		err := s.SendWebSocketMessage(data, v)
		if err != nil {
			return err
		}
	}

	return nil
}

const (
	ClientBoundSendChatMessageType  string = "send_chat_message"
	ClientBoundFetchChatMessageType        = "fetch_chat_messages"
	ServerBoundSendChatMessageType         = "send_chat_message"
)

type TypeMessage struct {
	Type string `json:"type" validate:"required"`
}
