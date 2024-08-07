package models

import (
	"gorm.io/gorm"
)

type Group struct {
	gorm.Model
	Name        string  `json:"name" gorm:"not null"`
	Description *string `json:"description" validate:"omitempty,max=100"`
	Code        string  `json:"code" gorm:"unique;not null" validate:"required,min=5,max=20"`
	Users       []User  `gorm:"many2many:group_users;" json:"users,omitempty"`
	OwnerID     uint    `json:"owner_id" validate:"required"`
}

type JoinGroupRequest struct {
	Code string `json:"code" gorm:"unique;not null" validate:"required,min=5,max=10"`
}

func (gc Group) ToGroup() *Group {
	return &Group{
		Name:        gc.Name,
		Description: gc.Description,
		Code:        gc.Code,
		OwnerID:     gc.OwnerID,
	}
}
