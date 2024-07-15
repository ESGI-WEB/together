package tests

import (
	"github.com/labstack/echo/v4"
	"github.com/labstack/gommon/random"
	"net/http"
	"net/http/httptest"
	"strconv"
	"strings"
	"testing"
	"together/database"
	"together/models"
	"together/routers"
	"together/tests/tests_utils"
)

func TestGroupRouter_Unauthorized(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.GroupRouter{})

	req := httptest.NewRequest(http.MethodGet, "/groups", nil)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusUnauthorized {
		t.Errorf("Expected status code %d, got %d", http.StatusUnauthorized, rec.Code)
	}
}

func TestGroupRouter_GetAllMyGroups(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.GroupRouter{})

	token, err := tests_utils.GetTokenForNewUser(models.UserRole)
	if err != nil {
		t.Error(err)
		return
	}

	req := httptest.NewRequest(http.MethodGet, "/groups", nil)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rec.Code)
	}
}

func TestGroupRouter_GetAllGroups(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.GroupRouter{})

	token, err := tests_utils.GetTokenForNewUser(models.AdminRole)
	if err != nil {
		t.Error(err)
		return
	}

	req := httptest.NewRequest(http.MethodGet, "/groups/all", nil)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rec.Code)
	}
}

func TestGroupRouter_GetGroupById(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.GroupRouter{})

	group := tests_utils.CreateGroup()

	var owner models.User
	database.CurrentDatabase.Find(&owner, group.OwnerID)

	token, _ := tests_utils.GetUserToken(owner.Email, tests_utils.Password)

	req := httptest.NewRequest(http.MethodGet, "/groups/"+strconv.Itoa(int(group.ID)), nil)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rec.Code)
	}
}

func TestGroupRouter_CreateGroup(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.GroupRouter{})

	token, err := tests_utils.GetTokenForNewUser(models.UserRole)
	if err != nil {
		t.Error(err)
		return
	}

	code := random.String(10)

	req := httptest.NewRequest(http.MethodPost, "/groups", strings.NewReader(`{"name":"test group", "code": "`+code+`"}`))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusCreated {
		t.Errorf("Expected status code %d, got %d", http.StatusCreated, rec.Code)
	}
}

func TestGroupRouter_JoinGroup(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.GroupRouter{})

	token, err := tests_utils.GetTokenForNewUser(models.UserRole)
	if err != nil {
		t.Error(err)
		return
	}

	group := tests_utils.CreateGroup()

	req := httptest.NewRequest(http.MethodPost, "/groups/join", strings.NewReader(`{"code": "`+group.Code+`"}`))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusCreated {
		t.Errorf("Expected status code %d, got %d", http.StatusCreated, rec.Code)
	}
}

func TestGroupRouter_GetNextEvent(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.GroupRouter{})

	group := tests_utils.CreateGroup()

	var owner models.User
	database.CurrentDatabase.Find(&owner, group.OwnerID)

	token, _ := tests_utils.GetUserToken(owner.Email, tests_utils.Password)

	req := httptest.NewRequest(http.MethodGet, "/groups/"+strconv.Itoa(int(group.ID))+"/next-event", nil)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rec.Code)
	}
}
