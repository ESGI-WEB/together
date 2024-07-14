package models

type PollAnswerChoiceUser struct {
	UserID             uint `gorm:"primaryKey" json:"user_id"`
	User               *User
	PollAnswerChoiceID uint `gorm:"primaryKey" json:"poll_answer_choice_id"`
	PollAnswerChoice   *PollAnswerChoice
}
