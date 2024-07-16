package services

import (
	"github.com/go-playground/validator/v10"
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

func (s *MessageService) GetMessageReactions(messageID uint) ([]string, error) {
	var reactions []models.Reaction
	if err := database.CurrentDatabase.Where("message_id = ?", messageID).Find(&reactions).Error; err != nil {
		return nil, err
	}

	reactionContents := make([]string, len(reactions))
	for i, reaction := range reactions {
		reactionContents[i] = reaction.Content
	}

	return reactionContents, nil
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

func (s *MessageService) updateMessageGeneric(messageID uint, updatedFields interface{}) (*models.Message, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	if err := validate.Struct(updatedFields); err != nil {
		return nil, err
	}

	existingMessage := &models.Message{}
	if err := database.CurrentDatabase.First(existingMessage, messageID).Error; err != nil {
		return nil, err
	}

	if err := database.CurrentDatabase.Model(existingMessage).Updates(updatedFields).Error; err != nil {
		return nil, err
	}

	if err := database.CurrentDatabase.Preload("User").First(existingMessage, messageID).Error; err != nil {
		return nil, err
	}

	return existingMessage, nil
}

func (s *MessageService) UpdateContent(messageID uint, updatedMessage models.MessageUpdate) (*models.Message, error) {
	return s.updateMessageGeneric(messageID, updatedMessage)
}

func (s *MessageService) PinnedMessage(messageID uint, updatedMessage models.MessagePinned) (*models.Message, error) {
	return s.updateMessageGeneric(messageID, updatedMessage)
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