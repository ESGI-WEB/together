package middlewares

import (
	"github.com/labstack/echo/v4"
	"net/http"
	"strconv"
	"together/models"
	"together/services"
)

func GroupMembershipMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		groupID, err := strconv.Atoi(c.Param("groupId"))
		if err != nil {
			return c.NoContent(http.StatusBadRequest)
		}

		user, ok := c.Get("user").(models.User)
		if !ok || user.ID == 0 {
			return c.JSON(http.StatusUnauthorized, "unauthorized")
		}

		isUserInGroup, err := services.NewGroupService().IsUserInGroup(user.ID, uint(groupID))
		if err != nil {
			return c.JSON(http.StatusInternalServerError, "internal server error")
		}

		if !isUserInGroup && !user.IsAdmin() {
			return c.JSON(http.StatusUnauthorized, "user does not belong to this group")
		}

		return next(c)
	}
}
