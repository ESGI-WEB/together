package tests

import (
	"fmt"
	"github.com/labstack/echo/v4"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"together/database"
	"together/models"
	"together/routers"
	"together/tests/tests_utils"
)

func TestEventRouter_Unauthorized(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.EventRouter{})

	tests := []struct {
		method, path string
	}{
		{http.MethodGet, "/events"},
		{http.MethodPost, "/events"},
		{http.MethodGet, "/events/1"},
		{http.MethodGet, "/events/1/attends"},
	}

	for _, tt := range tests {
		req := httptest.NewRequest(tt.method, tt.path, nil)
		req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
		rec := httptest.NewRecorder()
		e.ServeHTTP(rec, req)

		if rec.Code != http.StatusUnauthorized {
			t.Errorf("Expected status code %d, got %d", http.StatusUnauthorized, rec.Code)
		}
	}
}

type MockGroupService struct {
	isUserInGroupFunc func(userID, groupID uint) (bool, error)
}

func (m *MockGroupService) IsUserInGroup(userID, groupID uint) (bool, error) {
	return m.isUserInGroupFunc(userID, groupID)
}

func TestEventRouter_CreateEvent(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.EventRouter{})

	user, _ := tests_utils.CreateUser(models.UserRole)
	token, _ := tests_utils.GetUserToken(user.Email, tests_utils.Password)
	eventCreate := tests_utils.GetEventCreate()
	var group models.Group
	database.CurrentDatabase.Preload("Users").Find(&group, eventCreate.GroupID)

	// put the user in the group
	_ = database.CurrentDatabase.
		Table("group_users").
		Create(map[string]interface{}{"group_id": eventCreate.GroupID, "user_id": user.ID})

	eventJSON := `{
		"name": "` + eventCreate.Name + `",
		"description": "` + eventCreate.Description + `",
		"date": "2006-01-02",
		"type_id": ` + fmt.Sprint(eventCreate.TypeID) + `,
		"group_id": ` + fmt.Sprint(eventCreate.GroupID) + `,
		"organizer_id": ` + fmt.Sprint(eventCreate.OrganizerID) + `,
		"address": {
			"street": "` + eventCreate.Address.Street + `",
			"number": "` + eventCreate.Address.Number + `",
			"city": "` + eventCreate.Address.City + `",
			"zip": "` + eventCreate.Address.Zip + `"
		}
	}`

	req := httptest.NewRequest(http.MethodPost, "/events", strings.NewReader(eventJSON))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusCreated {
		t.Errorf("Expected status code %d, got %d", http.StatusCreated, rec.Code)
	}
}

func TestEventRouter_GetEvent(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.EventRouter{})

	token, err := tests_utils.GetTokenForNewUser(models.UserRole)
	if err != nil {
		t.Error(err)
		return
	}

	req := httptest.NewRequest(http.MethodGet, "/events/1", nil)
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rec.Code)
	}
}

func TestEventRouter_GetEventAttends(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.EventRouter{})

	token, err := tests_utils.GetTokenForNewUser(models.UserRole)
	if err != nil {
		t.Error(err)
		return
	}

	req := httptest.NewRequest(http.MethodGet, "/events/1/attends", nil)
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rec.Code)
	}
}

func TestEventRouter_GetEvents(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.EventRouter{})

	token, err := tests_utils.GetTokenForNewUser(models.UserRole)
	if err != nil {
		t.Error(err)
		return
	}

	req := httptest.NewRequest(http.MethodGet, "/events", nil)
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rec.Code)
	}
}
