package tests_utils

import (
	"github.com/labstack/gommon/random"
	"together/models"
	"together/services"
)

var Password = "Azerty1*"

func CreateUser(role models.Role) (*models.User, error) {
	userService := services.NewUserService()
	return userService.AddUser(GetValidUser(role))
}

func GetValidUser(role models.Role) models.User {
	return models.User{
		Name:          "John",
		Email:         "john.doe" + random.String(10) + "@email.com",
		PlainPassword: &Password,
		Role:          role,
	}
}

func GetUserToken(email string, password string) (*string, error) {
	security := services.NewSecurityService()
	login, err := security.Login(email, password)
	if err != nil {
		return nil, err
	}

	return &login.Token, nil
}

func GetTokenForNewUser(role models.Role) (*string, error) {
	user, err := CreateUser(role)
	if err != nil {
		return nil, err
	}

	return GetUserToken(user.Email, Password)
}
