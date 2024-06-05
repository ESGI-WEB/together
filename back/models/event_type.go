package models

import "gorm.io/gorm"

type EventType struct {
	gorm.Model
	Name        string `gorm:"unique;not null" json:"name"`
	Description string `json:"description"`
}
