package tests_utils

import (
	"github.com/labstack/gommon/random"
	"together/database"
	"together/models"
)

func CreateType() models.EventType {
	newType := models.EventType{
		Name:        random.String(10),
		Description: random.String(50),
		ImagePath:   random.String(20) + ".png",
	}

	database.CurrentDatabase.Create(&newType)

	return newType
}
