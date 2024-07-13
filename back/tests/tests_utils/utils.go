package tests_utils

import (
	"math/rand"
	"together/models"
	"together/services"
)

var password = "Azerty1*"

func CreateUser(role models.Role) (*models.User, error) {
	user := models.User{
		Name:          "John",
		Email:         "john.doe" + string(rune(rand.Intn(99999))) + "@email.com",
		PlainPassword: &password,
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

	return GetUserToken(user.Email, password)
}
