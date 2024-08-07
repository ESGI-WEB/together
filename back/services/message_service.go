package services

import (
	"errors"
	"github.com/go-playground/validator/v10"
	"time"
	"together/database"
	"together/models"
	"together/utils"
)

type MessageService struct {
}

func NewMessageService() *MessageService {
	return &MessageService{}
}

func (s *MessageService) CreateChatMessage(message models.Message) (*models.Message, error) {
	message.Type = models.ChatMessageType // Ensure the message type is set to chat message

	if err := database.CurrentDatabase.Create(&message).Error; err != nil {
		return nil, err
	}

	return &message, nil
}

func (s *MessageService) GetAllChatMessagesByGroup(groupID uint) ([]models.Message, error) {
	var messages []models.Message
	if err := database.CurrentDatabase.Preload("User").Where("group_id = ? AND type = ?", groupID, models.ChatMessageType).Find(&messages).Error; err != nil {
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

	// Check if the reaction already exists
	var existingReaction models.Reaction
	err = database.CurrentDatabase.Where(&models.Reaction{
		Content:   reactionContent,
		MessageID: messageID,
		UserID:    whoReacted.ID,
	}).First(&existingReaction).Error

	if err == nil {
		return nil, errors.New("reaction already exists")
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

func (s *MessageService) CreatePublication(message models.MessageCreate) (*models.Message, error) {
	message.Type = models.PubMessageType

	validate := validator.New(validator.WithRequiredStructEnabled())
	if err := validate.Struct(message); err != nil {
		return nil, err
	}

	newMessage := message.ToMessage()
	if err := database.CurrentDatabase.Create(&newMessage).Error; err != nil {
		return nil, err
	}

	if err := database.CurrentDatabase.Preload("User").First(&newMessage, newMessage.ID).Error; err != nil {
		return nil, err
	}

	return newMessage, nil
}

func (s *MessageService) UpdateContent(messageID uint, updatedMessage models.MessageUpdate) (*models.Message, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	if err := validate.Struct(updatedMessage); err != nil {
		return nil, err
	}

	existingMessage := &models.Message{}
	if err := database.CurrentDatabase.First(existingMessage, messageID).Error; err != nil {
		return nil, err
	}

	if err := database.CurrentDatabase.Model(existingMessage).Updates(updatedMessage).Error; err != nil {
		return nil, err
	}

	if err := database.CurrentDatabase.Preload("User").First(existingMessage, messageID).Error; err != nil {
		return nil, err
	}

	// force update the message's updated_at field
	// wierd gorm bug for this table
	if err := database.CurrentDatabase.Model(existingMessage).Update("updated_at", time.Now()).Error; err != nil {
		return nil, err
	}

	return existingMessage, nil
}

func (s *MessageService) PinnedMessage(messageID uint, updatedMessage models.MessagePinned) (*models.Message, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	if err := validate.Struct(updatedMessage); err != nil {
		return nil, err
	}

	existingMessage := &models.Message{}
	if err := database.CurrentDatabase.First(existingMessage, messageID).Error; err != nil {
		return nil, err
	}

	if err := database.CurrentDatabase.Model(existingMessage).Update("is_pinned", updatedMessage.IsPinned).Error; err != nil {
		return nil, err
	}

	if err := database.CurrentDatabase.Preload("User").First(existingMessage, messageID).Error; err != nil {
		return nil, err
	}

	// force update the message's updated_at field
	// wierd gorm bug for this table
	if err := database.CurrentDatabase.Model(existingMessage).Update("updated_at", time.Now()).Error; err != nil {
		return nil, err
	}

	return existingMessage, nil
}

func (s *MessageService) DeleteMessage(messageID uint) error {
	if err := database.CurrentDatabase.Delete(&models.Message{}, messageID).Error; err != nil {
		return err
	}
	return nil
}

func (s *MessageService) GetPublicationsByEventAndGroup(eventID, groupID uint, pagination utils.Pagination) (*utils.Pagination, error) {
	var messages []models.Message
	query := database.CurrentDatabase.Where("event_id = ? AND group_id = ? AND type = ?", eventID, groupID, models.PubMessageType).Order("is_pinned DESC").Find(&messages).Find(&messages)

	query.Scopes(utils.Paginate(messages, &pagination, query)).Find(&messages)

	pagination.Rows = messages

	return &pagination, nil
}

func (s *MessageService) GetPublicationsByGroup(groupID uint, pagination utils.Pagination) (*utils.Pagination, error) {
	var messages []models.Message
	query := database.CurrentDatabase.Where("group_id = ? AND type = ?", groupID, models.PubMessageType).Order("is_pinned DESC").Find(&messages).Preload("User")

	query.Scopes(utils.Paginate(messages, &pagination, query)).Find(&messages)

	pagination.Rows = messages

	return &pagination, nil
}
