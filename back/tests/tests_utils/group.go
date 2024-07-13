package tests_utils

import (
	"github.com/labstack/gommon/random"
	"together/database"
	"together/models"
)

func CreateGroup() models.Group {
	owner, _ := CreateUser(models.UserRole)
	group := models.Group{
		Name:    "Test Group",
		Code:    random.String(10),
		OwnerID: owner.ID,
	}
	database.CurrentDatabase.Create(&group)
	return group
}
