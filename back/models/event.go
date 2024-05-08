package models

import (
	"gorm.io/gorm"
)

type Event struct {
	gorm.Model
	Name         string
	Description  string
	Date         string
	Time         *string
	TypeID       uint
	Type         EventType
	AddressID    uint
	Address      Address
	CategoryID   uint
	Category     Category
	OrganizerID  uint
	Organizer    User   `gorm:"foreignKey:OrganizerID"`
	Participants []User `gorm:"many2many:attends;"`
}
