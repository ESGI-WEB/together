package services

import (
	"github.com/go-playground/validator/v10"
	"together/database"
	"together/models"
	"together/utils"
)

type DuplicateEventRequest struct {
	NewDate string `json:"new_date" validate:"required,datetime=2006-01-02"`
}

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
		Preload("Type").
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

func (s *EventService) DuplicateEvent(eventID uint, newDate string, userID uint) (*models.Event, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	err := validate.Var(newDate, "required,datetime=2006-01-02")
	if err != nil {
		return nil, err
	}

	originalEvent, err := s.GetEventByID(eventID)
	if err != nil {
		return nil, err
	}

	duplicatedEvent := *originalEvent
	duplicatedEvent.ID = 0
	duplicatedEvent.Date = newDate
	duplicatedEvent.OrganizerID = userID

	create := database.CurrentDatabase.Create(&duplicatedEvent)
	if create.Error != nil {
		return nil, create.Error
	}

	return &duplicatedEvent, nil
}

func (s *EventService) GetEvents(pagination utils.Pagination, filters ...EventFilter) (*utils.Pagination, error) {
	var events []models.Event
	query := database.CurrentDatabase.Model(models.Event{})

	if len(filters) > 0 {
		for _, filter := range filters {
			query = query.Where(filter.Column+" "+filter.Filter.Operator+" ?", filter.Filter.Value)
		}
	}

	err := query.Scopes(utils.Paginate(events, &pagination, query)).
		Find(&events).Error
	if err != nil {
		return nil, err
	}

	pagination.Rows = events

	return &pagination, nil
}

type EventFilter struct {
	database.Filter
	Column string `json:"column" validate:"required,oneof=organizer_id created_at date time type_id address_id group_id"`
}
