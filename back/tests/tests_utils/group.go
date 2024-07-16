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
	_ = database.CurrentDatabase.
		Table("group_users").
		Create(map[string]interface{}{"group_id": group.ID, "user_id": owner.ID})
	return group
}

func GetValidGroup() models.Group {
	owner, _ := CreateUser(models.UserRole)
	return models.Group{
		Name:    "Test Group",
		Code:    random.String(10),
		OwnerID: owner.ID,
	}
}

func GetInvalidGroup() models.Group {
	return models.Group{
		Code: random.String(10),
	}
}
