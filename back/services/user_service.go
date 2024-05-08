package services

import (
	"github.com/go-playground/validator/v10"
	"together/database"
	"together/errors"
	"together/models"
)

type UserService struct{}

func NewUserService() *UserService {
	return &UserService{}
}

func (s *UserService) AddUser(user models.UserCreate) (*models.User, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	err := validate.Struct(user)
	if err != nil {
		return nil, err
	}

	var existingUser models.User
	database.CurrentDatabase.Where("email = ?", user.Email).First(&existingUser)
	if existingUser.ID != 0 {
		return nil, errors.ErrUserAlreadyExists
	}

	user.Password, err = HashPassword(user.Password)
	if err != nil {
		return nil, err
	}

	newUser := user.ToUser()
	create := database.CurrentDatabase.Create(&newUser)
	if create.Error != nil {
		return nil, create.Error
	}

	return newUser, nil
}
