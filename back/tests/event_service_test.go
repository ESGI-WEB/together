package tests

import (
	"testing"
	"together/database"
	"together/models"
	"together/services"
	"together/tests/tests_utils"
	"together/utils"

	"github.com/stretchr/testify/assert"
)

func TestAddEvent_Success(t *testing.T) {
	service := services.NewEventService()

	eventCreate := tests_utils.GetEventCreate()
	event, err := service.AddEvent(eventCreate)

	assert.NoError(t, err)
	assert.NotNil(t, event)
	assert.Equal(t, eventCreate.Name, event.Name)
	assert.Equal(t, eventCreate.Description, event.Description)
	assert.Equal(t, eventCreate.Date, event.Date)
	assert.Equal(t, eventCreate.TypeID, event.TypeID)
	assert.Equal(t, eventCreate.GroupID, event.GroupID)
	assert.Equal(t, eventCreate.OrganizerID, event.OrganizerID)
	assert.Equal(t, eventCreate.Address.Street, event.Address.Street)
	assert.Equal(t, eventCreate.Address.Number, event.Address.Number)
	assert.Equal(t, eventCreate.Address.City, event.Address.City)
	assert.Equal(t, eventCreate.Address.Zip, event.Address.Zip)
}

func TestAddEvent_ValidationError(t *testing.T) {
	service := services.NewEventService()

	eventCreate := tests_utils.GetInvalidEventCreate()

	event, err := service.AddEvent(eventCreate)

	assert.Error(t, err)
	assert.Nil(t, event)
}

func TestGetEventByID_Success(t *testing.T) {
	service := services.NewEventService()

	event := tests_utils.CreateEvent()

	newEvent, err := service.GetEventByID(event.ID)

	assert.NoError(t, err)
	assert.NotNil(t, event)
	assert.Equal(t, event.ID, newEvent.ID)
}

func TestGetEventByID_NotFound(t *testing.T) {
	service := services.NewEventService()

	eventID := uint(0) // Assume an event with this ID does not exist

	event, err := service.GetEventByID(eventID)

	assert.Error(t, err)
	assert.Nil(t, event)
}

func TestGetEventAttends_Success(t *testing.T) {
	service := services.NewEventService()

	event := tests_utils.CreateEvent()
	user, _ := tests_utils.CreateUser(models.UserRole)

	database.CurrentDatabase.Create(&models.Attend{EventID: event.ID, UserID: user.ID, HasAttended: true})

	pagination := utils.Pagination{Limit: 10, Page: 1}
	hasAttended := true

	paginatedAttends, err := service.GetEventAttends(event.ID, pagination, &hasAttended)

	assert.NoError(t, err)
	assert.NotNil(t, paginatedAttends)
	assert.NotEmpty(t, paginatedAttends.Rows)
}

func TestGetEvents_Success(t *testing.T) {
	service := services.NewEventService()
	event := tests_utils.CreateEvent()

	pagination := utils.Pagination{Limit: 10, Page: 1}
	filters := []services.EventFilter{
		{Column: "organizer_id", Filter: database.Filter{Operator: "=", Value: event.OrganizerID}},
	}

	paginatedEvents, err := service.GetEvents(pagination, filters...)

	assert.NoError(t, err)
	assert.NotNil(t, paginatedEvents)
	assert.NotEmpty(t, paginatedEvents.Rows)
}
