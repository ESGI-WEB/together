package services

import (
	"github.com/go-playground/validator/v10"
	"gorm.io/gorm"
	"together/database"
	"together/models"
	"together/utils"
)

type PollService struct{}

func NewPollService() *PollService {
	return &PollService{}
}

func (s *PollService) CreatePoll(id uint, pollData models.PollCreateOrEdit) (*models.Poll, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	err := validate.Struct(pollData)
	if err != nil {
		return nil, err
	}

	poll := pollData.ToPoll(id)
	err = database.CurrentDatabase.Create(&poll).Error
	if err != nil {
		return nil, err
	}

	return &poll, nil
}

func (s *PollService) EditPoll(poll models.Poll) (*models.Poll, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	err := validate.Struct(poll)
	if err != nil {
		return nil, err
	}
	err = database.CurrentDatabase.Save(&poll).Error
	if err != nil {
		return nil, err
	}

	return &poll, nil
}

func (s *PollService) EditPollChoices(poll models.Poll, choices []models.PollAnswerChoice) error {
	choicesIds := make([]uint, len(choices))

	for _, choice := range choices {
		choicesIds = append(choicesIds, choice.ID)
	}

	// find poll choices that are not in the choices array and delete them
	err := database.CurrentDatabase.
		Where("poll_id = ? AND id NOT IN ?", poll.ID, choicesIds).
		Delete(&models.PollAnswerChoice{}).Error
	if err != nil {
		return err
	}

	for _, choice := range choices {
		err := database.CurrentDatabase.Save(&choice).Error
		if err != nil {
			return err
		}
	}

	return nil
}

func (s *PollService) DeletePoll(id uint) error {
	err := database.CurrentDatabase.Delete(&models.Poll{}, id).Error
	if err != nil {
		return err
	}

	return nil
}

func (s *PollService) GetPollByID(id uint) (*models.Poll, error) {
	var poll models.Poll
	err := database.CurrentDatabase.
		Preload("Choices", func(db *gorm.DB) *gorm.DB {
			return db.Order("ID").Preload("Users")
		}).
		First(&poll, id).Error
	if err != nil {
		return nil, err
	}

	return &poll, nil
}

func (s *PollService) AddPollChoice(pollID uint, option models.PollAnswerChoiceCreateOrEdit) (*models.PollAnswerChoice, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	err := validate.Struct(option)
	if err != nil {
		return nil, err
	}

	choice := option.ToPollAnswerChoice()
	choice.PollID = pollID
	err = database.CurrentDatabase.Create(&choice).Error
	if err != nil {
		return nil, err
	}

	return &choice, nil
}

func (s *PollService) DeletePollChoice(id uint) error {
	err := database.CurrentDatabase.Delete(&models.PollAnswerChoice{}, id).Error
	if err != nil {
		return err
	}

	return nil
}

func (s *PollService) GetPollChoiceByID(id uint) (*models.PollAnswerChoice, error) {
	var choice models.PollAnswerChoice
	err := database.CurrentDatabase.First(&choice, id).Error
	if err != nil {
		return nil, err
	}

	return &choice, nil
}

func (s *PollService) SelectPollChoice(user models.User, choice models.PollAnswerChoice, selectChoice bool) error {
	var err error

	if selectChoice {
		err = database.CurrentDatabase.Create(&models.PollAnswerChoiceUser{
			PollAnswerChoiceID: choice.ID,
			UserID:             user.ID,
		}).Error
	} else {
		err = database.CurrentDatabase.Where("poll_answer_choice_id = ? AND user_id = ?", choice.ID, user.ID).
			Delete(&models.PollAnswerChoiceUser{}).Error
	}

	return err
}

func (s *PollService) GetPollChoicesOfUser(pollID uint, userID uint) ([]models.PollAnswerChoice, error) {
	var choices []models.PollAnswerChoice
	err := database.CurrentDatabase.
		Joins("JOIN poll_answer_choice_users ON poll_answer_choices.id = poll_answer_choice_users.poll_answer_choice_id").
		Where("poll_answer_choices.poll_id = ? AND poll_answer_choice_users.user_id = ?", pollID, userID).
		Find(&choices).Error
	if err != nil {
		return nil, err
	}

	return choices, nil
}

func (s *PollService) GetPollsForGroup(groupID uint, pagination utils.Pagination, closed bool) (*utils.Pagination, error) {
	var polls []models.Poll

	query := database.CurrentDatabase.Where("group_id = ?", groupID).
		Where("is_closed = ?", closed).
		Preload("Choices", func(db *gorm.DB) *gorm.DB {
			return db.Order("ID").Preload("Users")
		})

	err := query.Scopes(utils.Paginate(polls, &pagination, query)).Find(&polls).Error
	if err != nil {
		return nil, err
	}

	pagination.Rows = polls

	return &pagination, nil
}

func (s *PollService) GetPollsForEvent(eventID uint, pagination utils.Pagination, closed bool) (*utils.Pagination, error) {
	var polls []models.Poll

	query := database.CurrentDatabase.Where("event_id = ?", eventID).
		Where("is_closed = ?", closed).
		Preload("Choices", func(db *gorm.DB) *gorm.DB {
			return db.Order("ID").Preload("Users")
		})

	err := query.Scopes(utils.Paginate(polls, &pagination, query)).Find(&polls).Error
	if err != nil {
		return nil, err
	}

	pagination.Rows = polls

	return &pagination, nil
}
