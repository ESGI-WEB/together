package services

import (
	"together/database"
	"together/models"
)

type FeatureFlippingService struct{}

func NewFeatureFlippingService() *FeatureFlippingService {
	return &FeatureFlippingService{}
}

func (s *FeatureFlippingService) IsFeatureEnabled(featureSlug models.FeatureSlug) bool {
	// find feature flipping in database and return if it is enabled (or true if not found)
	var feature models.FeatureFlipping
	database.CurrentDatabase.Where("slug = ?", featureSlug).First(&feature)
	return feature.Slug == "" || feature.Enabled
}
