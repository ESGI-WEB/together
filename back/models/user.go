package models

import "gorm.io/gorm"

type Role string

const (
	AdminRole Role = "admin"
	UserRole  Role = "user"
)

type User struct {
	gorm.Model
	Name              string             `json:"name" validate:"required,min=2,max=50"`
	Email             string             `gorm:"unique;<-:create" json:"email" validate:"email,required"`
	Password          string             `json:"-" validate:"required"`
	Role              Role               `gorm:"default:user" json:"role"`
	Biography         *string            `json:"biography"`
	AvatarPath        *string            `json:"avatar_path"`
	Groups            []Group            `gorm:"many2many:group_users;" json:"groups,omitempty"`
	PollAnswerChoices []PollAnswerChoice `gorm:"many2many:poll_answer_choice_users" json:"poll_answer_choices,omitempty"`
}

// TODO find a better solution for this
type UserCreate struct {
	Name       string  `json:"name" validate:"required,min=2,max=50"`
	Email      string  `json:"email" validate:"email,required"`
	Password   string  `json:"password" validate:"required,min=8,max=72"`
	Biography  *string `json:"biography"`
	AvatarPath *string `json:"avatar_path"`
}

func (u UserCreate) ToUser() *User {
	return &User{
		Name:       u.Name,
		Email:      u.Email,
		Password:   u.Password,
		Biography:  u.Biography,
		AvatarPath: u.AvatarPath,
	}
}
