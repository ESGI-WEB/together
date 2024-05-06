package models

import (
	"gorm.io/gorm"
)

type PollAnswerChoice struct {
	gorm.Model
	Choice string
	PollID uint
	Poll   Poll
	Users  []User `gorm:"many2many:poll_answer_choice_users"`
}
