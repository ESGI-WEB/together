package tests

import (
	"github.com/golang-jwt/jwt/v5"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"os"
	"testing"
	"time"
	"together/database"
	"together/models"
	"together/services"
)

func TestHashPassword_Success(t *testing.T) {
	service := services.NewSecurityService()

	password := "securepassword1A*"
	hashedPassword, err := service.HashPassword(password)

	require.NoError(t, err)
	assert.NotEmpty(t, hashedPassword)
}

func TestCheckPasswordHash_Success(t *testing.T) {
	service := services.NewSecurityService()

	password := "securepassword1A*"
	hashedPassword, _ := service.HashPassword(password)

	isValid := service.CheckPasswordHash(password, hashedPassword)

	assert.True(t, isValid)
}

func TestCheckPasswordHash_Invalid(t *testing.T) {
	service := services.NewSecurityService()

	password := "securepassword1A*"
	hashedPassword, _ := service.HashPassword(password)

	isValid := service.CheckPasswordHash("wrongpassword", hashedPassword)

	assert.False(t, isValid)
}

func TestLogin_Success(t *testing.T) {
	setupTestDB()
	service := services.NewSecurityService()

	password := "securepassword1A*"
	hashedPassword, _ := service.HashPassword(password)

	user := models.User{
		Email:    "test@example.com",
		Password: hashedPassword,
	}
	database.CurrentDatabase.Create(&user)

	os.Setenv("JWT_KEY", "mysecretkey")

	loginResponse, err := service.Login(user.Email, password)

	require.NoError(t, err)
	assert.NotNil(t, loginResponse)
	assert.NotEmpty(t, loginResponse.Token)
}

func TestLogin_InvalidCredentials(t *testing.T) {
	setupTestDB()
	service := services.NewSecurityService()

	user := models.User{
		Email:    "test@example.com",
		Password: "wrongpassword",
	}
	database.CurrentDatabase.Create(&user)

	loginResponse, err := service.Login(user.Email, "wrongpassword")

	assert.Error(t, err)
	assert.Nil(t, loginResponse)
}

func TestValidateToken_Success(t *testing.T) {
	service := services.NewSecurityService()

	os.Setenv("JWT_KEY", "mysecretkey")

	tokenString, _ := generateTestToken()

	token, err := service.ValidateToken(tokenString)

	require.NoError(t, err)
	assert.NotNil(t, token)
}

func TestValidateToken_Invalid(t *testing.T) {
	service := services.NewSecurityService()

	os.Setenv("JWT_KEY", "mysecretkey")

	invalidTokenString := "invalidtoken"

	token, err := service.ValidateToken(invalidTokenString)

	assert.Error(t, err)
	assert.Nil(t, token)
}

func generateTestToken() (string, error) {
	jwtSecret := "mysecretkey"
	t := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"id":    1,
		"name":  "Test User",
		"email": "test@example.com",
		"role":  "user",
		"exp":   time.Now().Add(4 * time.Hour).Unix(),
		"iat":   time.Now().Unix(),
	})
	return t.SignedString([]byte(jwtSecret))
}
