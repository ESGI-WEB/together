package services

import "together/models"

type HelloService struct{}

func NewHelloService() *HelloService {
	return &HelloService{}
}

func (s *HelloService) GetHelloMessage() string {
	return "Hello, World!"
}

func (s *HelloService) GetHelloUserMessage(user models.User) string {
	return "Hello, " + user.Name + "! You are an logged in :D."
}
