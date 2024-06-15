package models

import (
	"gorm.io/gorm"
)

type MessageType string

const (
	TChatMessageType MessageType = "chat"
	PubMessageType   MessageType = "publication"
)

type Message struct {
	gorm.Model
	Type     MessageType `json:"type" gorm:"default:tchat"`
	Content  string      `json:"content" validate:"required,min=10,max=300"`
	IsPinned bool        `gorm:"default:false;not null" json:"is_pinned"`
	GroupID  uint        `json:"group_id" validate:"required"`
	Group    Group       `gorm:"foreignkey:GroupID" json:"group"`
	UserID   uint        `json:"user_id" validate:"required"`
	User     User        `gorm:"foreignkey:UserID" json:"user"`
	EventID  *uint       `json:"event_id"`
	Event    *Event      `gorm:"foreignkey:EventID" json:"event,omitempty"`
}

type MessageCreate struct {
	Type     MessageType `json:"-" gorm:"default:tchat"`
	Content  string      `json:"content" validate:"required,min=10,max=300"`
	IsPinned bool        `gorm:"default:false;not null" json:"is_pinned"`
	GroupID  uint        `json:"group_id" validate:"required"`
	UserID   uint        `json:"-"`
	EventID  *uint       `json:"event_id"`
}

func (e MessageCreate) ToMessage() *Message {
	return &Message{
		Type:     e.Type,
		Content:  e.Content,
		IsPinned: e.IsPinned,
		GroupID:  e.GroupID,
		UserID:   e.UserID,
		EventID:  e.EventID,
	}
}
