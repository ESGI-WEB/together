package services

import (
	"errors"
	"github.com/go-playground/validator/v10"
	"gorm.io/gorm"
	"time"
	"together/database"
	coreErrors "together/errors"
	"together/models"
)

type GroupService struct{}

func NewGroupService() *GroupService {
	return &GroupService{}
}

func (s *GroupService) CreateGroup(group models.Group) (*models.Group, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	if err := validate.Struct(group); err != nil {
		return nil, err
	}

	newGroup := group.ToGroup()
	if err := database.CurrentDatabase.Create(newGroup).Error; err != nil {
		return nil, err
	}

	return newGroup, nil
}

func (s *GroupService) GetGroupById(id uint) (*models.Group, error) {
	var group models.Group
	if err := database.CurrentDatabase.Preload("Users").First(&group, id).Error; err != nil {
		return nil, err
	}
	return &group, nil
}

func (s *GroupService) GetAllMyGroups(userID uint) ([]models.Group, error) {
	var groups []models.Group
	if err := database.CurrentDatabase.Joins("JOIN group_users ON group_users.group_id = groups.id").
		Where("group_users.user_id = ?", userID).
		Preload("Users").
		Find(&groups).Error; err != nil {
		return nil, err
	}
	return groups, nil
}

func (s *GroupService) JoinGroup(code string, user models.User) (*models.Group, error) {
	var group models.Group

	if err := database.CurrentDatabase.Where("code = ?", code).Preload("Users").First(&group).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, coreErrors.ErrCodeDoesNotExist
		}

		return nil, err
	}

	if err := database.CurrentDatabase.First(&user, user.ID).Error; err != nil {
		return nil, err
	}

	for _, u := range group.Users {
		if u.ID == user.ID {
			return nil, coreErrors.ErrUserAlreadyInGroup
		}
	}

	if err := database.CurrentDatabase.Model(&group).Association("Users").Append(&user); err != nil {
		return nil, err
	}

	updatedGroup, err := s.GetGroupById(group.ID)
	if err != nil {
		return nil, err
	}

	return updatedGroup, nil
}

type GroupUserRoles string

func (s *GroupService) IsUserInGroup(userId, groupId uint) (bool, error) {
	var group models.Group

	err := database.CurrentDatabase.Joins(
		"JOIN group_users ON group_users.group_id = groups.id AND group_users.user_id = ?", userId,
	).Where("groups.id = ?", groupId).First(&group).Error

	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return false, nil
		}
		return false, err
	}

	return group.ID != 0, nil
}

func (s *GroupService) GetNextEvent(groupId uint) (*models.Event, error) {
	var event models.Event

	err := database.CurrentDatabase.
		Preload("Participants").
		Preload("Address").
		Where("group_id = ?", groupId).
		// display only if date is later or eq today and if time, check that date is later or time is later (meaning date is today)
		Where("date >= ?", time.Now().Format(models.DateFormat)).
		Where("time is null or (date > ? or time >= ?)", time.Now().Format(models.DateFormat), time.Now().Format(models.TimeFormat)).
		Order("date").
		Order("time").
		First(&event).Error

	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &event, nil
}
