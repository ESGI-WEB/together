package models

import "gorm.io/gorm"

type EventType struct {
	gorm.Model
	Name        string `gorm:"unique;not null" json:"name" form:"name" validate:"required,min=3,max=255"`
	Description string `json:"description" form:"description" validate:"required"`
	ImagePath   string `json:"image_path" gorm:"not null, default:'storage/images/default.jpg'"`
	Image       string `json:"-" form:"image" gorm:"-"`
}
