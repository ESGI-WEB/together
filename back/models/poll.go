package models

import (
	"gorm.io/gorm"
)

type Poll struct {
	gorm.Model
	Question string
	IsClosed bool
	GroupID  uint
	Group    Group
	UserID   uint
	User     User
	EventID  *uint
	Event    *Event
}
