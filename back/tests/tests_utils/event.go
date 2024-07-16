package tests_utils

import (
	"together/database"
	"together/models"
)

func GetEventCreate() models.EventCreate {
	newGroup := CreateGroup()
	address := GetAddressCreate()
	eventCreate := models.EventCreate{
		Name:        "Test Event",
		Description: "This is a test event",
		Date:        "2021-01-01",
		TypeID:      CreateType().ID,
		GroupID:     newGroup.ID,
		OrganizerID: newGroup.OwnerID,
		Address:     &address,
	}
	return eventCreate
}

func CreateEvent() models.Event {
	eventCreate := GetEventCreate().ToEvent()
	database.CurrentDatabase.Create(&eventCreate)
	return *eventCreate
}

func GetInvalidEventCreate() models.EventCreate {
	return models.EventCreate{
		Description: "This is a test event",
		Date:        "2021-01-01",
	}
}
