package models

import (
	"gorm.io/gorm"
)

type Reaction struct {
	gorm.Model
	Content   string
	MessageID uint    `json:"message_id" validate:"required"`
	Message   Message `gorm:"foreignkey:MessageID" json:"message"`
	UserID    uint    `json:"user_id" validate:"required"`
	User      User    `gorm:"foreignkey:UserID" json:"user"`
}
