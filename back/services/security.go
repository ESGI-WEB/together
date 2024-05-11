package services

import (
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
	"os"
	"time"
	"together/database"
	"together/errors"
	"together/models"
)

type SecurityService struct{}

func NewSecurityService() *SecurityService {
	return &SecurityService{}
}

func (s *SecurityService) HashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
	return string(bytes), err
}

func (s *SecurityService) CheckPasswordHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}

type LoginResponse struct {
	Token string `json:"token"`
}

func (s *SecurityService) Login(email, password string) (*LoginResponse, error) {
	var targetUser models.User
	database.CurrentDatabase.Where("email = ?", email).First(&targetUser)

	if targetUser.ID == 0 {
		return nil, errors.ErrInvalidCredentials
	}

	if !s.CheckPasswordHash(password, targetUser.Password) {
		return nil, errors.ErrInvalidCredentials
	}

	jwtSecret, ok := os.LookupEnv("JWT_KEY")
	if !ok {
		return nil, errors.ErrInternal
	}

	t := jwt.NewWithClaims(jwt.SigningMethodHS256,
		jwt.MapClaims{
			"id":    targetUser.ID,
			"name":  targetUser.Name,
			"email": targetUser.Email,
			"role":  targetUser.Role,
			"exp":   time.Now().Add(4 * time.Hour).Unix(),
			"iat":   time.Now().Unix(),
		},
	)

	token, err := t.SignedString([]byte(jwtSecret))
	if err != nil {
		return nil, errors.ErrInternal
	}

	return &LoginResponse{Token: token}, nil
}

func (s *SecurityService) ValidateToken(tokenString string) (*jwt.Token, error) {
	jwtSecret, ok := os.LookupEnv("JWT_KEY")
	if !ok {
		return nil, errors.ErrInternal
	}

	return jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		return []byte(jwtSecret), nil
	})
}
