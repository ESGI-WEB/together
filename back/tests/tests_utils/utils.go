package tests_utils

import (
	"github.com/labstack/gommon/random"
	"together/models"
	"together/services"
)

var Password = "Azerty1*"

func CreateUser(role models.Role) (*models.User, error) {
	user := models.User{
		Name:          "John",
		Email:         "john.doe" + random.String(10) + "@email.com",
		PlainPassword: &Password,
		Role:          role,
	}

	userService := services.NewUserService()
	return userService.AddUser(user)
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
