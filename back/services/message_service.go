package services

type MessageService struct{}

func NewMessageService() *MessageService {
	return &MessageService{}
}

func (s *MessageService) GetMessageService() string {
	return "Hello, World!"
}
