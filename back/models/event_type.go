package models

import "gorm.io/gorm"

type EventType struct {
	gorm.Model
	Name        string `gorm:"unique;not null" json:"name" form:"name" validate:"required,min=3,max=30"`
	Description string `json:"description" form:"description" validate:"required"`
	ImagePath   string `json:"image_path" gorm:"not null, default:'storage/images/default.jpg'"`
}

const MaxFileSize = 10 * 1024 * 1024 // 10MB
