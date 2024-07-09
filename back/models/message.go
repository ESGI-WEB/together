package models

import (
	"gorm.io/gorm"
)

type MessageType string

const (
	TChatMessageType MessageType = "tchat"
	PubMessageType   MessageType = "publication"
)

type Message struct {
	gorm.Model
	Type    MessageType `gorm:"default:tchat"`
	Content string      `json:"content" validate:"required"`
	IsPined bool        `json:"isPined" gorm:"default:false"`
	GroupID uint        `json:"groupID" validate:"required"`
	Group   Group       `gorm:"foreignkey:GroupID"`
	UserID  uint        `json:"userID" validate:"required"`
	User    User        `gorm:"foreignkey:UserID"`
	EventID *uint       `json:"eventID"`
	Event   *Event      `gorm:"foreignkey:EventID"`
}

type CreateMessageReaction struct {
	ReactionContent string `json:"reaction"`
}
