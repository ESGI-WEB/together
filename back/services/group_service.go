package services

import (
	"errors"
	"github.com/go-playground/validator/v10"
	"gorm.io/gorm"
	"together/database"
	"together/models"
)

type GroupService struct{}

func NewGroupService() *GroupService {
	return &GroupService{}
}

func (s *GroupService) CreateGroup(group models.Group) (*models.Group, error) {
	validate := validator.New()
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

func (s *GroupService) JoinGroup(request models.JoinGroupRequest) error {
	var group models.Group
	if err := database.CurrentDatabase.Where("code = ?", request.Code).First(&group).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return errors.New("Le code n'existe pas.")
		}
		return err
	}

	var user models.User
	if err := database.CurrentDatabase.First(&user, request.UserId).Error; err != nil {
		return err
	}

	for _, u := range group.Users {
		if u.ID == request.UserId {
			return errors.New("L'utilisateur est déjà dans le groupe.")
		}
	}

	if err := database.CurrentDatabase.Model(&group).Association("Users").Append(&user); err != nil {
		return err
	}

	return nil
}
