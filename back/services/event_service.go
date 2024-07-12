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
		Where("event_id = ?", eventID).
		Order("updated_at DESC") // get the latest attend first

	if hasAttended != nil {
		query = query.Where("has_attended = ?", *hasAttended)
	}

	query.Preload("User").
		Scopes(utils.Paginate(attends, &pagination, query)).
		Find(&attends)
	pagination.Rows = attends

	return &pagination, nil
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

func (s *EventService) GetUserEventAttend(eventID uint, userID uint, preloads ...string) *models.Attend {
	var attend models.Attend
	query := database.CurrentDatabase.Where("event_id = ? AND user_id = ?", eventID, userID)

	if len(preloads) > 0 {
		for _, preload := range preloads {
			query = query.Preload(preload)
		}
	}

	query.First(&attend)

	if attend.UserID == 0 {
		return nil
	}

	return &attend
}

func (s *EventService) ChangeUserEventAttend(isAttending bool, eventID uint, userID uint) (*models.Attend, error) {
	// check if a user event attend already exists to update
	// if not, create a new one
	attend := s.GetUserEventAttend(eventID, userID)
	if attend == nil {
		attend = &models.Attend{
			EventID:     eventID,
			UserID:      userID,
			HasAttended: isAttending,
		}

		err := database.CurrentDatabase.Create(&attend).Error
		if err != nil {
			return nil, err
		}
		return attend, nil
	} else {
		attend.HasAttended = isAttending
		err := database.CurrentDatabase.Save(&attend).Error
		if err != nil {
			return nil, err
		}
		return attend, nil
	}
}

type EventFilter struct {
	database.Filter
	Column string `json:"column" validate:"required,oneof=organizer_id created_at date time type_id address_id group_id"`
}
