package services

import (
	"encoding/json"
	"github.com/go-playground/validator/v10"
	"together/models"
)

type MessageService struct {
	groupService *GroupService
}

func NewMessageService() *MessageService {
	return &MessageService{
		groupService: NewGroupService(),
	}
}

func (s *MessageService) handleSendChatMessage(wsService *WebSocketService, msg []byte, user models.User) error {
	var receivedMessage ClientBoundSendChatMessage
	if err := json.Unmarshal(msg, &receivedMessage); err != nil {
		return err
	}

	validate := validator.New(validator.WithRequiredStructEnabled())
	if err := validate.Struct(receivedMessage); err != nil {
		return err
	}

	isInGroup, err := s.groupService.IsUserInGroup(user.ID, receivedMessage.GroupID)
	if !isInGroup {
		return nil
	}
	if err != nil {
		return err
	}

	response := ServerBoundSendChatMessage{
		TypeMessage: TypeMessage{
			Type: ServerBoundSendChatMessageType,
		},
		Content: receivedMessage.Content,
		Author:  &user,
		GroupID: receivedMessage.GroupID,
	}

	bytes, err := json.Marshal(response)
	if err != nil {
		return err
	}

	// TODO: Only broadcast to the members of the group
	if err := wsService.BroadcastWebSocketMessage(bytes); err != nil {
		return err
	}
	return nil
}

type ClientBoundSendChatMessage struct {
	TypeMessage
	Content string `json:"content" validate:"required"`
	GroupID uint   `json:"group_id" validate:"required"`
}

type ServerBoundSendChatMessage struct {
	TypeMessage
	Content string       `json:"content" validate:"required"`
	Author  *models.User `json:"author" validate:"required"`
	GroupID uint         `json:"group_id" validate:"required"`
}
