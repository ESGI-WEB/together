package services

import (
	"encoding/json"
	"github.com/go-playground/validator/v10"
	"github.com/gorilla/websocket"
	"together/models"
)

type MessageService struct {
	connections []*websocket.Conn
}

func NewMessageService() *MessageService {
	return &MessageService{
		connections: make([]*websocket.Conn, 0),
	}
}

func (s *MessageService) AcceptNewConnection(ws *websocket.Conn) func(ws *websocket.Conn) {
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

func (s *MessageService) HandleMessage(msg []byte, user models.User) error {
	var decodedMessage TypeMessage
	if err := json.Unmarshal(msg, &decodedMessage); err != nil {
		return err
	}
	switch decodedMessage.Type {
	case ClientBoundSendChatMessageType:
		if err := s.handleSendChatMessage(msg, user); err != nil {
			return err
		}
	}
	return nil
}

func (s *MessageService) SendMessage(message ServerBoundSendChatMessage, v *websocket.Conn) error {
	bytes, err := json.Marshal(message)
	if err != nil {
		return err
	}
	err = v.WriteMessage(websocket.TextMessage, bytes)

	if err != nil {
		return err
	}
	return nil
}

func (s *MessageService) Broadcast(message ServerBoundSendChatMessage) error {
	for _, v := range s.connections {
		err := s.SendMessage(message, v)
		if err != nil {
			return err
		}
	}

	return nil
}

func (s *MessageService) handleSendChatMessage(msg []byte, user models.User) error {
	var receivedMessage ClientBoundSendChatMessage
	if err := json.Unmarshal(msg, &receivedMessage); err != nil {
		return err
	}

	validate := validator.New(validator.WithRequiredStructEnabled())
	if err := validate.Struct(receivedMessage); err != nil {
		return err
	}

	response := ServerBoundSendChatMessage{
		TypeMessage: TypeMessage{
			Type: ServerBoundSendChatMessageType,
		},
		Content: receivedMessage.Content,
		Author:  &user,
	}
	if err := s.Broadcast(response); err != nil {
		return err
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

type ClientBoundSendChatMessage struct {
	TypeMessage
	Content string `json:"content" validate:"required"`
}

type ServerBoundSendChatMessage struct {
	TypeMessage
	Content string       `json:"content" validate:"required"`
	Author  *models.User `json:"author" validate:"required"`
}
