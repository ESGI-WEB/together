package services

import (
	"github.com/go-playground/validator/v10"
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

func (s *FeatureFlippingService) GetBySlug(featureSlug models.FeatureSlug) *models.FeatureFlipping {
	// find feature flipping in database and return it
	var feature models.FeatureFlipping
	database.CurrentDatabase.Where("slug = ?", featureSlug).First(&feature)
	return &feature
}

func (s *FeatureFlippingService) List() []models.FeatureFlipping {
	var features []models.FeatureFlipping
	database.CurrentDatabase.Find(&features)
	return features
}

func (s *FeatureFlippingService) Edit(feature *models.FeatureFlipping, data models.EditFeatureFlipping) (*models.FeatureFlipping, error) {
	// validate
	validate := validator.New(validator.WithRequiredStructEnabled())
	err := validate.Struct(data)
	if err != nil {
		return nil, err
	}

	// for each data field, update feature flipping
	if data.Enabled != nil {
		feature.Enabled = *data.Enabled
	}

	// save to database
	database.CurrentDatabase.Save(feature)
	return feature, nil
}
