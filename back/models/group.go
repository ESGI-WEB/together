package models

import (
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type Group struct {
	gorm.Model
	Name        string  `json:"name" gorm:"not null"`
	Description *string `json:"description" validate:"max=100"`
	Code        string  `json:"code" gorm:"unique, not null" validate:"required,min=5,max=10"`
	Users       []User  `gorm:"many2many:group_users;"`
}

type JoinGroupRequest struct {
	Code string `json:"code" validate:"required,min=5,max=10"`
}

func (gc Group) ToGroup() (Group, error) {
	hashedCode, err := bcrypt.GenerateFromPassword([]byte(gc.Code), bcrypt.DefaultCost)
	if err != nil {
		return Group{}, err
	}

	return Group{
		Name:        gc.Name,
		Description: gc.Description,
		Code:        string(hashedCode),
	}, nil
}
