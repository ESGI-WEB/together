package services

import (
	"errors"
	"github.com/go-playground/validator/v10"
	"time"
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

func (s *EventService) getNextDate(currentDate time.Time, recurrenceType string) time.Time {
	switch recurrenceType {
	case string(models.EachDays):
		return currentDate.AddDate(0, 0, 1)
	case string(models.EachWeeks):
		return currentDate.AddDate(0, 0, 7)
	case string(models.EachMonths):
		return currentDate.AddDate(0, 1, 0)
	case string(models.EachYears):
		return currentDate.AddDate(1, 0, 0)
	default:
		return currentDate
	}
}

func (s *EventService) DuplicateEventForYear(eventID uint, userID uint) ([]models.Event, error) {
	originalEvent, err := s.GetEventByID(eventID)
	if err != nil {
		return nil, err
	}

	if originalEvent.RecurrenceType == nil {
		return nil, errors.New("event does not have a recurrence type")
	}

	var duplicatedEvents []models.Event
	currentDate, _ := time.Parse(models.DateFormat, originalEvent.Date)
	endDate := currentDate.AddDate(1, 0, 0)

	currentDate = s.getNextDate(currentDate, string(*originalEvent.RecurrenceType))

	for currentDate.Before(endDate) {
		duplicatedEvent := *originalEvent
		duplicatedEvent.ID = 0
		duplicatedEvent.OrganizerID = userID
		duplicatedEvent.Date = currentDate.Format(models.DateFormat)

		create := database.CurrentDatabase.Create(&duplicatedEvent)
		if create.Error != nil {
			return nil, create.Error
		}

		duplicatedEvents = append(duplicatedEvents, duplicatedEvent)

		currentDate = s.getNextDate(currentDate, string(*originalEvent.RecurrenceType))

	}

	return duplicatedEvents, nil
}

func (s *EventService) DuplicateEventsForTomorrow() error {
	tomorrow := time.Now().AddDate(0, 0, 1).Format(models.DateFormat)

	var events []models.Event
	result := database.CurrentDatabase.
		Where("date = ?", tomorrow).
		Where("recurrence_type IS NOT NULL").
		Find(&events)
	if result.Error != nil {
		return result.Error
	}

	for _, event := range events {
		newEvent := event
		newEvent.ID = 0
		newEvent.Date = time.Now().AddDate(1, 0, 1).Format(models.DateFormat)

		create := database.CurrentDatabase.Create(&newEvent)
		if create.Error != nil {
			return create.Error
		}
	}

	return nil
}
