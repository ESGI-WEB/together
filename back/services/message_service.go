package services

import (
	"together/database"
	"together/models"
)

type MessageService struct {
}

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

func (s *MessageService) GetAllChatMessagesByGroup(groupID uint) ([]models.Message, error) {
	var messages []models.Message
	if err := database.CurrentDatabase.Preload("User").Where("group_id = ? AND type = ?", groupID, models.TChatMessageType).Find(&messages).Error; err != nil {
		return nil, err
	}
	return messages, nil
}

func (s *MessageService) GetMessageReactions(messageID uint) (map[string]int, error) {
	var reactions []models.Reaction
	if err := database.CurrentDatabase.Where("message_id = ?", messageID).Find(&reactions).Error; err != nil {
		return nil, err
	}

	reactionCounts := make(map[string]int)
	for _, reaction := range reactions {
		reactionCounts[reaction.Content]++
	}

	return reactionCounts, nil
}

func (s *MessageService) ReactToMessage(messageID uint, reactionContent string, whoReacted models.User) (*models.Reaction, error) {
	message, err := s.GetMessage(messageID)
	if err != nil {
		return nil, err
	}

	reaction := models.Reaction{
		Content:   reactionContent,
		Message:   *message,
		User:      whoReacted,
		MessageID: message.ID,
		UserID:    whoReacted.ID,
	}

	if err := database.CurrentDatabase.Create(&reaction).Error; err != nil {
		return nil, err
	}

	return &reaction, nil
}

func (s *MessageService) GetMessage(messageID uint) (*models.Message, error) {
	var message models.Message
	if err := database.CurrentDatabase.Preload("User").First(&message, messageID).Error; err != nil {
		return nil, err
	}
	return &message, nil
}
