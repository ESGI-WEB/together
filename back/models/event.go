package models

import (
	"gorm.io/gorm"
)

// YYYY-MM-DD
const DateFormat = "2006-01-02"
const TimeFormat = "15:04"

type Event struct {
	gorm.Model
	Name         string     `json:"name" validate:"required,min=2,max=100"`
	Description  string     `json:"description" validate:"required"`
	Date         string     `json:"date" validate:"required,datetime=2006-01-02"`
	Time         *string    `json:"time" validate:"omitempty,datetime=15:04"`
	TypeID       uint       `json:"type_id"`
	Type         *EventType `json:"type,omitempty"`
	AddressID    uint       `json:"address_id"`
	Address      *Address   `json:"address,omitempty"`
	OrganizerID  uint       `json:"organizer_id"`
	Organizer    *User      `json:"organizer,omitempty"`
	GroupID      uint       `json:"group_id"`
	Group        *Group     `json:"group,omitempty"`
	Participants []User     `gorm:"many2many:attends;" json:"participants,omitempty"`
}

type EventCreate struct {
	Name        string         `json:"name" validate:"required,min=2,max=100"`
	Description string         `json:"description" validate:"required"`
	Date        string         `json:"date" validate:"required,datetime=2006-01-02"`
	Time        *string        `json:"time" validate:"omitempty,datetime=15:04"`
	TypeID      uint           `json:"type_id" validate:"required"`
	GroupID     uint           `json:"group_id" validate:"required"`
	OrganizerID uint           `json:"-" validate:"required"`
	Address     *AddressCreate `json:"address" validate:"required"`
}

func (e EventCreate) ToEvent() *Event {
	return &Event{
		Name:        e.Name,
		Description: e.Description,
		Date:        e.Date,
		Time:        e.Time,
		TypeID:      e.TypeID,
		GroupID:     e.GroupID,
		Address:     e.Address.ToAddress(),
		OrganizerID: e.OrganizerID,
	}
}
