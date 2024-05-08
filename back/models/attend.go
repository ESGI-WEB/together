package models

import (
	"time"
)

type Attend struct {
	UserID      int `gorm:"primaryKey"`
	EventID     int `gorm:"primaryKey"`
	hasAttended bool
	CreatedAt   time.Time
	UpdatedAt   time.Time
}
