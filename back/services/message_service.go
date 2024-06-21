package services

import (
	"together/database"
	"together/models"
)

type MessageService struct{}

func NewMessageService() *MessageService {
	return &MessageService{}
}

func (s *MessageService) CreateChatMessage(message models.Message) (*models.Message, error) {
	message.Type = models.TChatMessageType // Ensure the message type is set to chat message

	if err := database.CurrentDatabase.Create(&message).Error; err != nil {
		return nil, err
	}

	return &message, nil
}

func (s *MessageService) GetChatMessageByGroup(groupID uint) ([]models.Message, error) {
	var messages []models.Message
	if err := database.CurrentDatabase.Where("group_id = ? AND type = ?", groupID, models.TChatMessageType).Find(&messages).Error; err != nil {
		return nil, err
	}
	return messages, nil
}
