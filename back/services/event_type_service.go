package services

import (
	"fmt"
	"github.com/go-playground/validator/v10"
	"mime/multipart"
	"together/database"
	"together/models"
)

type EventTypeService struct{}

func NewEventTypeService() *EventTypeService {
	return &EventTypeService{}
}

func (s *EventTypeService) GetAllEventTypes() ([]models.EventType, error) {
	var eventTypes []models.EventType
	result := database.CurrentDatabase.Find(&eventTypes)
	if result.Error != nil {
		return nil, result.Error
	}
	return eventTypes, nil
}

func (s *EventTypeService) CreateEventType(eventType models.EventType, file multipart.FileHeader) (*models.EventType, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	err := validate.Struct(eventType)
	if err != nil {
		return nil, err
	}

	filePath, err := NewStorageService().SaveFile(file, eventType.Name)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}
	eventType.ImagePath = filePath

	result := database.CurrentDatabase.Create(&eventType)
	if result.Error != nil {
		return nil, result.Error
	}

	return &eventType, nil
}
