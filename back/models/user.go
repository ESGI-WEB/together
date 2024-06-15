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
	Email             string             `gorm:"uniqueIndex:idx_email_deleted_at" json:"email" validate:"email,required"`
	Password          string             `json:"-"`
	ColorHex          string             `json:"color_hex" gorm:"default:'#000000'" validate:"omitempty,hexcolor"`
	Role              Role               `gorm:"default:user" json:"role" validate:"omitempty,oneof=admin user"`
	Biography         *string            `json:"biography,omitempty"`
	AvatarPath        *string            `json:"avatar_path,omitempty"`
	Groups            []Group            `gorm:"many2many:group_users;" json:"groups,omitempty"`
	PollAnswerChoices []PollAnswerChoice `gorm:"many2many:poll_answer_choice_users" json:"poll_answer_choices,omitempty"`
	DeletedAt         gorm.DeletedAt     `gorm:"uniqueIndex:idx_email_deleted_at"`
	PlainPassword     *string            `gorm:"-" json:"password,omitempty" validate:"required_without=Password,omitempty,min=8,max=72"`
}

type UserLogin struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required,min=8,max=72"`
}

type LoginResponse struct {
	Token string `json:"token"`
}

func (u User) IsAdmin() bool {
	return u.Role == AdminRole
}
