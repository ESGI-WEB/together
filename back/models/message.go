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
	Content string
	IsPined string
	GroupID uint
	Group   Group
	UserID  uint
	User    User
	EventID *uint
	Event   *Event
}
