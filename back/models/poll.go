package models

import (
	"gorm.io/gorm"
)

type Poll struct {
	gorm.Model
	Question   string              `gorm:"not null" json:"question" validate:"required,min=3,max=255"`
	IsClosed   bool                `gorm:"default:false" json:"is_closed" validate:"boolean"`
	IsMultiple bool                `gorm:"default:false" json:"is_multiple" validate:"boolean"`
	GroupID    uint                `gorm:"not null" json:"group_id" validate:"required"`
	Group      *Group              `json:"group,omitempty"`
	UserID     uint                `gorm:"not null" json:"user_id"`
	User       *User               `json:"user,omitempty"`
	EventID    *uint               `gorm:"default:null" json:"event_id" validate:"omitempty"`
	Event      *Event              `json:"event,omitempty"`
	Choices    *[]PollAnswerChoice `json:"choices,omitempty" validate:"required,min=1,dive,required"`
}

type PollCreateOrEdit struct {
	Question   *string                         `json:"question" validate:"required,min=3,max=255"`
	IsClosed   *bool                           `json:"is_closed" validate:"omitempty,boolean"`
	IsMultiple *bool                           `json:"is_multiple" validate:"omitempty,boolean"`
	GroupID    *uint                           `json:"group_id" validate:"required"`
	EventID    *uint                           `json:"event_id" validate:"omitempty"`
	Choices    *[]PollAnswerChoiceCreateOrEdit `json:"choices,omitempty" validate:"required,min=1,dive,required"`
}

func (p *PollCreateOrEdit) ToPoll(userId uint) Poll {
	var choices []PollAnswerChoice
	for _, choice := range *p.Choices {
		choices = append(choices, choice.ToPollAnswerChoice())
	}

	var isClosed = false
	if p.IsClosed != nil {
		isClosed = *p.IsClosed
	}

	var isMultiple = false
	if p.IsMultiple != nil {
		isMultiple = *p.IsMultiple
	}

	return Poll{
		Question:   *p.Question,
		IsClosed:   isClosed,
		IsMultiple: isMultiple,
		GroupID:    *p.GroupID,
		EventID:    p.EventID,
		UserID:     userId,
		Choices:    &choices,
	}
}
