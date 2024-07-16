package tests

import (
	"github.com/labstack/echo/v4"
	"net/http"
	"net/http/httptest"
	"strconv"
	"strings"
	"testing"
	"together/models"
	"together/routers"
	"together/tests/tests_utils"
)

func TestUserRouter_CreateUser(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.UserRouter{})
	user := tests_utils.GetValidUser(models.UserRole)

	req := httptest.NewRequest(http.MethodPost, "/users", strings.NewReader(`{
		"name":"`+user.Name+`",
		"email":"`+user.Email+`",
		"password":"`+tests_utils.Password+`"
	}`))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusCreated {
		t.Errorf("Expected status code %d, got %d", http.StatusCreated, rec.Code)
	}
}

func TestUserRouter_CreateUserValidationFailed(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.UserRouter{})

	req := httptest.NewRequest(http.MethodPost, "/users", strings.NewReader(`{"name":"testuser", "password":"testpass"}`))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusUnprocessableEntity {
		t.Errorf("Expected status code %d, got %d", http.StatusUnprocessableEntity, rec.Code)
	}
}

func TestUserRouter_GetUsers(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.UserRouter{})

	token, err := tests_utils.GetTokenForNewUser(models.AdminRole)
	if err != nil {
		t.Error(err)
		return
	}

	req := httptest.NewRequest(http.MethodGet, "/users", nil)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rec.Code)
	}
}

func TestUserRouter_UpdateUser(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.UserRouter{})

	user, _ := tests_utils.CreateUser(models.UserRole)
	token, _ := tests_utils.GetUserToken(user.Email, tests_utils.Password)

	req := httptest.NewRequest(http.MethodPut, "/users/"+strconv.Itoa(int(user.ID)), strings.NewReader(`{"username":"testuser", "password":"testpass"}`))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rec.Code)
	}
}

func TestUserRouter_DeleteUser(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.UserRouter{})

	user, _ := tests_utils.CreateUser(models.UserRole)

	token, err := tests_utils.GetTokenForNewUser(models.AdminRole)
	if err != nil {
		t.Error(err)
		return
	}

	req := httptest.NewRequest(http.MethodDelete, "/users/"+strconv.Itoa(int(user.ID)), nil)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusNoContent {
		t.Errorf("Expected status code %d, got %d", http.StatusNoContent, rec.Code)
	}
}
