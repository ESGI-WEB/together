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

func TestAddressRouter_Unauthorized(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.AddressRouter{})

	req := httptest.NewRequest(http.MethodPost, "/addresses", strings.NewReader(`{"key":"value"}`))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusUnauthorized {
		t.Errorf("Expected status code %d, got %d", http.StatusUnauthorized, rec.Code)
	}
}

func TestAddressRouter_CreateAddress(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.AddressRouter{})

	token, err := tests_utils.GetTokenForNewUser(models.UserRole)
	if err != nil {
		t.Error(err)
		return
	}

	req := httptest.NewRequest(http.MethodPost, "/addresses", strings.NewReader(`{
		"street": "street",
		"number": "number",
		"city": "city",
		"zip": "zip",
		"latitude": 1.0,
		"longitude": 1.0
	}`))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusCreated {
		t.Errorf("Expected status code %d, got %d", http.StatusCreated, rec.Code)
	}
}

func TestAddressRouter_ValidationError(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.AddressRouter{})

	token, err := tests_utils.GetTokenForNewUser(models.UserRole)
	if err != nil {
		t.Error(err)
		return
	}

	req := httptest.NewRequest(http.MethodPost, "/addresses", strings.NewReader(`{
		"number": "number",
		"city": "city",
		"zip": "zip",
		"latitude": 1.0
	}`))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusUnprocessableEntity {
		t.Errorf("Expected status code %d, got %d", http.StatusBadRequest, rec.Code)
	}
}
