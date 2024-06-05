package services

import (
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
