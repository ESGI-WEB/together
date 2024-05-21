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

type GroupCreate struct {
	Name        string  `json:"name" validate:"required"`
	Description *string `json:"description"`
	Code        string  `json:"code" validate:"required"`
}

func (gc GroupCreate) ToGroup() Group {
	return Group{
		Name:        gc.Name,
		Description: gc.Description,
		Code:        gc.Code,
	}
}
