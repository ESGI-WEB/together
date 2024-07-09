package services

import (
	"encoding/json"
	"github.com/go-playground/validator/v10"
	"github.com/gorilla/websocket"
	"together/models"
)

type WebSocketConnection struct {
	connection *websocket.Conn
	user       *models.User
}

var connections = make([]*WebSocketConnection, 0)

type WebSocketService struct {
	messageService *MessageService
	groupService   *GroupService
}

func NewWebSocketService() *WebSocketService {
	return &WebSocketService{
		messageService: NewMessageService(),
		groupService:   NewGroupService(),
	}
}

func (s *WebSocketService) AcceptNewWebSocketConnection(ws *websocket.Conn, user *models.User) func(ws *websocket.Conn) {
	wsConnection := WebSocketConnection{
		connection: ws,
		user:       user,
	}
	connections = append(connections, &wsConnection)

	return func(ws *websocket.Conn) {
		_ = ws.Close()

		// Remove the closed web socket from the connection list
		for index, connection := range connections {
			if connection.connection == ws {
				connections = append(connections[:index], connections[index+1:]...)
				break
			}
		}
	}
}

func (s *WebSocketService) HandleWebSocketMessage(msg []byte, user *models.User, ws *websocket.Conn) error {
	var decodedMessage TypeMessage
	if err := json.Unmarshal(msg, &decodedMessage); err != nil {
		return err
	}
	switch decodedMessage.Type {
	case ClientBoundSendChatMessageType:
		if err := s.handleSendChatMessage(msg, user); err != nil {
			return err
		}
	case ClientBoundFetchChatMessageType:
		if err := s.handleFetchChatMessage(msg, ws); err != nil {
			return err
		}
	}
	return nil
}

func (s *WebSocketService) sendWebSocketMessage(data []byte, v *websocket.Conn) error {
	err := v.WriteMessage(websocket.TextMessage, data)

	if err != nil {
		return err
	}
	return nil
}

func (s *WebSocketService) Broadcast(data []byte) error {
	for _, connection := range connections {
		err := s.sendWebSocketMessage(data, connection.connection)
		if err != nil {
			return err
		}
	}

	return nil
}

func (s *WebSocketService) BroadcastToGroup(data []byte, groupId uint) error {
	for _, connection := range connections {
		//isInGroup, err := s.groupService.IsUserInGroup(connection.user.ID, groupId)
		//if err != nil || !isInGroup {
		//	continue
		//}

		err := s.sendWebSocketMessage(data, connection.connection)
		if err != nil {
			return err
		}
	}

	return nil
}

func (s *WebSocketService) handleSendChatMessage(msg []byte, user *models.User) error {
	var receivedMessage ClientBoundSendChatMessage
	if err := json.Unmarshal(msg, &receivedMessage); err != nil {
		return err
	}

	validate := validator.New(validator.WithRequiredStructEnabled())
	if err := validate.Struct(receivedMessage); err != nil {
		return err
	}

	isInGroup, err := s.groupService.IsUserInGroup(user.ID, receivedMessage.GroupId)
	if !isInGroup {
		return nil
	}
	if err != nil {
		return err
	}

	message := models.Message{
		Content: receivedMessage.Content,
		GroupID: receivedMessage.GroupId,
		UserID:  user.ID,
		EventID: nil,
	}
	_, err = s.messageService.CreateChatMessage(message)
	if err != nil {
		return err
	}

	response := ServerBoundSendChatMessage{
		TypeMessage: TypeMessage{
			Type: ServerBoundSendChatMessageType,
		},
		Content: receivedMessage.Content,
		Author:  user,
		GroupId: receivedMessage.GroupId,
	}

	bytes, err := json.Marshal(response)
	if err != nil {
		return err
	}

	if err := s.BroadcastToGroup(bytes, receivedMessage.GroupId); err != nil {
		return err
	}
	return nil
}

func (s *WebSocketService) handleFetchChatMessage(msg []byte, ws *websocket.Conn) error {
	var receivedMessage ClientBoundFetchChatMessage
	if err := json.Unmarshal(msg, &receivedMessage); err != nil {
		return err
	}

	validate := validator.New(validator.WithRequiredStructEnabled())
	if err := validate.Struct(receivedMessage); err != nil {
		return err
	}

	groupMessages, err := s.messageService.GetChatMessageByGroup(receivedMessage.GroupId)
	if err != nil {
		return err
	}

	for _, groupMessage := range groupMessages {
		response := ServerBoundSendChatMessage{
			TypeMessage: TypeMessage{
				Type: ServerBoundSendChatMessageType,
			},
			Content: groupMessage.Content,
			Author:  &groupMessage.User,
			GroupId: groupMessage.GroupID,
		}

		bytes, err := json.Marshal(response)
		if err != nil {
			return err
		}

		err = s.sendWebSocketMessage(bytes, ws)
		if err != nil {
			return err
		}
	}

	return nil
}

type ClientBoundSendChatMessage struct {
	TypeMessage
	Content string `json:"content" validate:"required"`
	GroupId uint   `json:"group_id" validate:"required"`
}

type ServerBoundSendChatMessage struct {
	TypeMessage
	Content string       `json:"content" validate:"required"`
	Author  *models.User `json:"author" validate:"required"`
	GroupId uint         `json:"group_id" validate:"required"`
}

type ClientBoundFetchChatMessage struct {
	TypeMessage
	GroupId uint `json:"group_id" validate:"required"`
}

type ServerBoundGroupBroadcast struct {
	TypeMessage
	Content interface{} `json:"content" validate:"required"`
	GroupId uint        `json:"group_id" validate:"required"`
}

const (
	ClientBoundSendChatMessageType    string = "send_chat_message"
	ClientBoundFetchChatMessageType          = "fetch_chat_messages"
	ServerBoundSendChatMessageType           = "send_chat_message"
	ServerBoundPollUpdatedMessageType        = "poll_updated"
)

type TypeMessage struct {
	Type string `json:"type" validate:"required"`
}
