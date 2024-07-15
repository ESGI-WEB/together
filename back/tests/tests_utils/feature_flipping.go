package tests_utils

import (
	"together/database"
	"together/models"
)

func CreateFeatureFlipping(slug models.FeatureSlug, enabled bool) models.FeatureFlipping {
	feature := models.FeatureFlipping{
		Slug:    slug,
		Enabled: enabled,
	}
	database.CurrentDatabase.Create(&feature)
	return feature
}
