package models

import (
	"gorm.io/gorm"
)

type Reaction struct {
	gorm.Model
	Content   string  `json:"content" validate:"required"`
	MessageID uint    `json:"messageID" validate:"required"`
	Message   Message `gorm:"foreignkey:MessageID"`
	UserID    uint    `json:"userID" validate:"required"`
	User      User    `gorm:"foreignkey:UserID"`
}
