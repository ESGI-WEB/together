package services

import (
	"github.com/go-playground/validator/v10"
	"together/database"
	"together/models"
	"together/utils"
)

type EventService struct{}

func NewEventService() *EventService {
	return &EventService{}
}

func (s *EventService) AddEvent(event models.EventCreate) (*models.Event, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	err := validate.Struct(event)
	if err != nil {
		return nil, err
	}

	newEvent := event.ToEvent()
	create := database.CurrentDatabase.Create(&newEvent)
	if create.Error != nil {
		return nil, create.Error
	}

	return newEvent, nil
}

func (s *EventService) GetEventByID(eventID uint) (*models.Event, error) {
	var event models.Event
	result := database.CurrentDatabase.
		Preload("Address").
		Preload("Organizer").
		First(&event, eventID)
	if result.Error != nil {
		return nil, result.Error
	}

	return &event, nil
}

func (s *EventService) GetEventAttends(eventID uint, pagination utils.Pagination, hasAttended *bool) (*utils.Pagination, error) {
	var attends []models.Attend

	query := database.CurrentDatabase.
		Where("event_id = ?", eventID)

	if hasAttended != nil {
		query = query.Where("has_attended = ?", *hasAttended)
	}

	query.Preload("User").
		Scopes(utils.Paginate(attends, &pagination, query)).
		Find(&attends)
	pagination.Rows = attends

	return &pagination, nil
}
