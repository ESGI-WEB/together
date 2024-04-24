package models

import (
	"gorm.io/gorm"
)

type Reaction struct {
	gorm.Model
	Content   string
	MessageID uint
	Message   Message
	UserID    uint
	User      User
}
