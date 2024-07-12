package models

import (
	"gorm.io/gorm"
)

type PollAnswerChoice struct {
	gorm.Model
	Choice string  `gorm:"not null" json:"choice" validate:"required,min=1,max=255"`
	PollID uint    `gorm:"not null" json:"poll_id" validate:"required"`
	Poll   *Poll   `json:"poll,omitempty"`
	Users  *[]User `gorm:"many2many:poll_answer_choice_users" json:"users,omitempty"`
}

type PollAnswerChoiceCreateOrEdit struct {
	Choice string `gorm:"not null" json:"choice" validate:"required,min=1,max=255"`
	ID     *uint  `json:"id,omitempty" validate:"omitempty,number"`
}

func (p *PollAnswerChoiceCreateOrEdit) ToPollAnswerChoice() PollAnswerChoice {
	return PollAnswerChoice{
		Choice: p.Choice,
	}
}
