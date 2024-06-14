package services

import (
	"github.com/go-playground/validator/v10"
	"together/database"
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

func (s *MessageService) GetChatMessageByGroup(groupID uint) ([]models.Message, error) {
	var messages []models.Message
	if err := database.CurrentDatabase.Where("group_id = ? AND type = ?", groupID, models.TChatMessageType).Find(&messages).Error; err != nil {
		return nil, err
	}
	return messages, nil
}
