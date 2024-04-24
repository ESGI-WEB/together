package models

import (
	"gorm.io/gorm"
)

type Group struct {
	gorm.Model
	Name        string
	Description *string
	Code        string
	Users       []User `gorm:"many2many:group_users;"`
}
