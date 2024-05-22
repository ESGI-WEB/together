package services

import (
	"errors"
	"github.com/go-playground/validator/v10"
	"golang.org/x/crypto/bcrypt"
	"together/database"
	"together/models"
)

type GroupService struct{}

func NewGroupService() *GroupService {
	return &GroupService{}
}

func (s *GroupService) CreateGroup(group models.Group) (*models.Group, error) {
	validate := validator.New()
	err := validate.Struct(group)
	if err != nil {
		return nil, err
	}

	newGroup, err := group.ToGroup()
	if err != nil {
		return nil, err
	}

	create := database.CurrentDatabase.Create(&newGroup)
	if create.Error != nil {
		return nil, create.Error
	}

	return &newGroup, nil
}

func (s *GroupService) GetGroupById(id uint) (*models.Group, error) {
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

// TODO get real current log user and fix request
func (s *GroupService) JoinGroup(request models.JoinGroupRequest) error {
	const fictifId = 1

	if err := bcrypt.CompareHashAndPassword([]byte(request.Code), []byte(request.Code)); err != nil {
		return errors.New("Code incorrect")
	}

	var group models.Group
	if err := database.CurrentDatabase.Where("code = ?", request.Code).First(&group).Error; err != nil {
		return err
	}

	var user models.User
	if err := database.CurrentDatabase.First(fictifId).Error; err != nil {
		return err
	}

	for _, u := range group.Users {
		if u.ID == 1 {
			return errors.New("L'utilisateur est déjà dans le groupe")
		}
	}

	if err := database.CurrentDatabase.Model(&group).Association("Users").Append(&user); err != nil {
		return err
	}

	return nil
}
