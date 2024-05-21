package middlewares

import (
	"github.com/golang-jwt/jwt/v5"
	"github.com/labstack/echo/v4"
	"net/http"
	"strings"
	"together/database"
	"together/models"
	"together/services"
)

var AuthenticationMiddleware = func(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		bearer := c.Request().Header.Get("Authorization")

		if len(bearer) == 0 || strings.HasPrefix(bearer, "Bearer ") == false {
			return c.JSON(http.StatusUnauthorized, "unauthorized")
		}

		token, err := services.NewSecurityService().ValidateToken(bearer[7:]) // remove "Bearer " (7 chars) from the token
		if err != nil {
			return c.JSON(http.StatusUnauthorized, "unauthorized")
		}

		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok || !token.Valid {
			return c.JSON(http.StatusUnauthorized, "unauthorized")
		}

		userID := claims["id"]
		var existingUser models.User
		database.CurrentDatabase.Find(&existingUser, userID)
		if existingUser.ID == 0 {
			return c.JSON(http.StatusUnauthorized, "unauthorized")
		}

		c.Set("user", existingUser)

		return next(c)
	}
}
