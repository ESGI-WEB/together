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

func TestFeatureRouter_Unauthorized(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.FeatureRouter{})

	req := httptest.NewRequest(http.MethodGet, "/features", nil)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusUnauthorized {
		t.Errorf("Expected status code %d, got %d", http.StatusUnauthorized, rec.Code)
	}
}

func TestFeatureRouter_ListFeatures(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.FeatureRouter{})

	token, err := tests_utils.GetTokenForNewUser(models.AdminRole)
	if err != nil {
		t.Error(err)
		return
	}

	req := httptest.NewRequest(http.MethodGet, "/features", nil)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rec.Code)
	}
}

func TestFeatureRouter_ViewFeature(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.FeatureRouter{})

	tests_utils.CreateFeatureFlipping("some-slug", true)

	req := httptest.NewRequest(http.MethodGet, "/features/some-slug", nil)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rec.Code)
	}
}

func TestFeatureRouter_ViewNotFoundFeature(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.FeatureRouter{})

	req := httptest.NewRequest(http.MethodGet, "/features/some-slug-not-found", nil)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusNotFound, rec.Code)
	}
}

func TestFeatureRouter_EditFeature(t *testing.T) {
	e := echo.New()

	routers.LoadRoutes(e, &routers.FeatureRouter{})

	token, err := tests_utils.GetTokenForNewUser(models.AdminRole)
	if err != nil {
		t.Error(err)
		return
	}

	tests_utils.CreateFeatureFlipping("some-slug", false)

	req := httptest.NewRequest(http.MethodPatch, "/features/some-slug", strings.NewReader(`{"enabled":true}`))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	req.Header.Set(echo.HeaderAuthorization, "Bearer "+*token)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rec.Code)
	}
}
