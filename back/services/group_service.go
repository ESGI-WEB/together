package services

import (
	"github.com/go-playground/validator/v10"
	"together/database"
	"together/models"
)

type GroupService struct{}

func NewGroupService() *GroupService {
	return &GroupService{}
}

func (s *GroupService) AddGroup(group models.GroupCreate) (*models.Group, error) {
	validate := validator.New()
	err := validate.Struct(group)
	if err != nil {
		return nil, err
	}

	newGroup := group.ToGroup()
	create := database.CurrentDatabase.Create(&newGroup)
	if create.Error != nil {
		return nil, create.Error
	}

	return &newGroup, nil
}

func (s *GroupService) GetGroupByID(id uint) (*models.Group, error) {
	var group models.Group
	err := database.CurrentDatabase.Preload("Users").First(&group, id).Error
	if err != nil {
		return nil, err
	}
	return &group, nil
}

func (s *GroupService) GetAllGroups() ([]models.Group, error) {
	var groups []models.Group
	err := database.CurrentDatabase.Preload("Users").Find(&groups).Error
	if err != nil {
		return nil, err
	}
	return groups, nil
}
