package services

import (
	"github.com/go-playground/validator/v10"
	"github.com/labstack/gommon/random"
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

	user.Password, err = NewSecurityService().HashPassword(user.Password)
	if err != nil {
		return nil, err
	}

	if user.ColorHex == nil || *user.ColorHex == "" {
		colorHex := s.GenerateAvatarColorHex()
		user.ColorHex = &colorHex
	}

	newUser := user.ToUser()
	create := database.CurrentDatabase.Create(&newUser)
	if create.Error != nil {
		return nil, create.Error
	}

	return newUser, nil
}

func (s *UserService) GenerateAvatarColorHex() string {
	color := "#" + random.String(6, "0123456789ABCDEF")
	return color
}
