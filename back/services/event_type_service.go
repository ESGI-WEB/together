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
	result := database.CurrentDatabase.
		Order("name asc").
		Find(&eventTypes)
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

func (s *EventTypeService) UpdateEventType(eventType models.EventType, file *multipart.FileHeader) (*models.EventType, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	err := validate.Struct(eventType)
	if err != nil {
		return nil, err
	}

	oldPath := eventType.ImagePath

	if file != nil {
		filePath, err := NewStorageService().SaveFile(*file, eventType.Name)
		if err != nil {
			return nil, err
		}
		eventType.ImagePath = filePath
	}

	result := database.CurrentDatabase.Save(&eventType)
	if result.Error != nil {
		return nil, result.Error
	}

	// if path has changed, delete the old image
	// ignore error if unable to delete
	if file != nil && eventType.ImagePath != oldPath {
		_ = NewStorageService().DeleteFile(oldPath)
	}

	return &eventType, nil
}
