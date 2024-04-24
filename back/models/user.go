package models

import "gorm.io/gorm"

type Role string

const (
	AdminRole Role = "admin"
	UserRole  Role = "user"
)

type User struct {
	gorm.Model
	Name              string
	Email             string `gorm:"unique;<-:create"`
	Password          string
	Biography         *string
	AvatarPath        *string
	Role              Role               `gorm:"default:user"`
	Groups            []Group            `gorm:"many2many:group_users;"`
	PollAnswerChoices []PollAnswerChoice `gorm:"many2many:poll_answer_choice_users"`
}
