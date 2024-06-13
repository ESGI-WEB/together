package services

import (
	"encoding/json"
	"github.com/go-playground/validator/v10"
	"github.com/gorilla/websocket"
	"together/database"
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

func (s *MessageService) CreatePublication(message models.Message) (*models.Message, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	if err := validate.Struct(message); err != nil {
		return nil, err
	}

	message.Type = models.PubMessageType // Ensure the message type is set to publication

	if err := database.CurrentDatabase.Create(&message).Error; err != nil {
		return nil, err
	}

	return &message, nil
}

func (s *MessageService) UpdateMessage(messageID uint, updatedData models.Message) (*models.Message, error) {
	var message models.Message
	if err := database.CurrentDatabase.First(&message, messageID).Error; err != nil {
		return nil, err
	}

	// Prevent changing the type
	updatedData.Type = message.Type

	if err := database.CurrentDatabase.Model(&message).Updates(updatedData).Error; err != nil {
		return nil, err
	}

	return &message, nil
}

func (s *MessageService) DeleteMessage(messageID uint) error {
	if err := database.CurrentDatabase.Delete(&models.Message{}, messageID).Error; err != nil {
		return err
	}
	return nil
}

func (s *MessageService) PinMessage(messageID uint, pin bool) (*models.Message, error) {
	var message models.Message
	if err := database.CurrentDatabase.First(&message, messageID).Error; err != nil {
		return nil, err
	}

	message.IsPined = pin
	if err := database.CurrentDatabase.Save(&message).Error; err != nil {
		return nil, err
	}

	return &message, nil
}

func (s *MessageService) GetPublicationsByEventAndGroup(eventID, groupID uint) ([]models.Message, error) {
	var messages []models.Message
	if err := database.CurrentDatabase.Where("event_id = ? AND group_id = ? AND type = ?", eventID, groupID, models.PubMessageType).Find(&messages).Error; err != nil {
		return nil, err
	}
	return messages, nil
}

func (s *MessageService) GetPublicationsByGroup(groupID uint) ([]models.Message, error) {
	var messages []models.Message
	if err := database.CurrentDatabase.Where("group_id = ? AND type = ?", groupID, models.PubMessageType).Find(&messages).Error; err != nil {
		return nil, err
	}
	return messages, nil
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
