package services

import (
	"github.com/go-playground/validator/v10"
	"together/database"
	"together/models"
)

type EventService struct{}

func NewEventService() *EventService {
	return &EventService{}
}

func (s *EventService) AddEvent(event models.EventCreate, id uint) (*models.Event, error) {
	validate := validator.New()
	err := validate.Struct(event)
	if err != nil {
		return nil, err
	}

	newEvent := event.ToEvent(id)
	create := database.CurrentDatabase.Create(&newEvent)
	if create.Error != nil {
		return nil, create.Error
	}

	return newEvent, nil
}

func (s *EventService) GetEventByID(eventID uint) (*models.Event, error) {
	var event models.Event
	result := database.CurrentDatabase.First(&event, eventID)
	if result.Error != nil {
		return nil, result.Error
	}
	return &event, nil
}
