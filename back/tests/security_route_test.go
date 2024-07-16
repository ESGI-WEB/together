package tests

import (
	"github.com/labstack/echo/v4"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"together/models"
	"together/routers"
	"together/tests/tests_utils"
)

func TestSecurityRouter_Login(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.SecurityRouter{})

	user, _ := tests_utils.CreateUser(models.UserRole)

	req := httptest.NewRequest(http.MethodPost, "/security/login", strings.NewReader(`{"email" : "`+user.Email+`", "password" : "`+tests_utils.Password+`"}`))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rec.Code)
	}
}

func TestSecurityRouter_InvalidPassword(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.SecurityRouter{})

	user, _ := tests_utils.CreateUser(models.UserRole)

	req := httptest.NewRequest(http.MethodPost, "/security/login", strings.NewReader(`{"email" : "`+user.Email+`", "password" : "invalidPWD"}`))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusUnauthorized {
		t.Errorf("Expected status code %d, got %d", http.StatusUnauthorized, rec.Code)
	}
}

func TestSecurityRouter_InvalidEmail(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.SecurityRouter{})

	req := httptest.NewRequest(http.MethodPost, "/security/login", strings.NewReader(`{"email" : "invalid@invalid.fr", "password" : "invalidPWD"}`))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusUnauthorized {
		t.Errorf("Expected status code %d, got %d", http.StatusUnauthorized, rec.Code)
	}
}
