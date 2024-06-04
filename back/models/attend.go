package models

import (
	"time"
)

type Attend struct {
	UserID      int       `gorm:"primaryKey" json:"user_id"`
	User        *User     `gorm:"foreignKey:UserID" json:"user,omitempty"`
	EventID     int       `gorm:"primaryKey" json:"event_id"`
	Event       *Event    `gorm:"foreignKey:EventID" json:"event,omitempty"`
	HasAttended bool      `gorm:"default:false;not null" json:"has_attended"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}
