package models

import (
	"time"
)

type EventType struct {
	ID          uint `gorm:"primarykey"`
	CreatedAt   time.Time
	UpdatedAt   time.Time
	Name        string  `gorm:"unique;not null" json:"name" form:"name" validate:"required,min=3,max=30"`
	Description string  `json:"description" form:"description" validate:"required"`
	ImagePath   string  `json:"image_path" gorm:"not null, default:'storage/images/types/default.png'"`
	Events      []Event `gorm:"foreignKey:TypeID"`
}

const MaxFileSize = 10 * 1024 * 1024 // 10MB
const EventTypeFolder = "types"
