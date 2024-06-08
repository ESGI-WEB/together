package models

import "gorm.io/gorm"

type Role string

const (
	AdminRole Role = "admin"
	UserRole  Role = "user"
)

type User struct {
	gorm.Model
	ColorHex          string             `json:"color_hex" gorm:"default:'#000000'" validate:"hexcolor"`
	Name              string             `json:"name" validate:"required,min=2,max=50"`
	Email             string             `gorm:"unique;<-:create" json:"email" validate:"email,required"`
	Password          string             `json:"-" validate:"required"`
	Role              Role               `gorm:"default:user" json:"role"`
	Biography         *string            `json:"biography"`
	AvatarPath        *string            `json:"avatar_path"`
	Groups            []Group            `gorm:"many2many:group_users;" json:"groups,omitempty"`
	PollAnswerChoices []PollAnswerChoice `gorm:"many2many:poll_answer_choice_users" json:"poll_answer_choices,omitempty"`
}

type UserCreate struct {
	Name       string  `json:"name" validate:"required,min=2,max=50"`
	Email      string  `json:"email" validate:"email,required"`
	Password   string  `json:"password" validate:"required,min=8,max=72"`
	ColorHex   *string `json:"color_hex" validate:"omitempty,hexcolor"`
	Biography  *string `json:"biography"`
	AvatarPath *string `json:"avatar_path"`
}

type UserLogin struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required,min=8,max=72"`
}

type LoginResponse struct {
	Token string `json:"token"`
}

func (u UserCreate) ToUser() *User {
	return &User{
		Name:       u.Name,
		Email:      u.Email,
		Password:   u.Password,
		Biography:  u.Biography,
		AvatarPath: u.AvatarPath,
		ColorHex:   *u.ColorHex,
	}
}
