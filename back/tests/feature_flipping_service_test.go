package tests

import (
	"testing"
	"together/database"
	"together/models"
	"together/services"
	"together/tests/tests_utils"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestIsFeatureEnabled_FeatureExists(t *testing.T) {
	setupTestDB()
	service := services.NewFeatureFlippingService()

	feature := tests_utils.CreateFeatureFlipping("test-feature", true)

	enabled := service.IsFeatureEnabled(feature.Slug)

	assert.True(t, enabled)
}

func TestIsFeatureEnabled_FeatureNotExists(t *testing.T) {
	setupTestDB()
	service := services.NewFeatureFlippingService()

	enabled := service.IsFeatureEnabled("non-existent-feature")

	assert.True(t, enabled)
}

func TestGetBySlug_FeatureExists(t *testing.T) {
	setupTestDB()
	service := services.NewFeatureFlippingService()

	feature := tests_utils.CreateFeatureFlipping("test-feature", true)

	retrievedFeature := service.GetBySlug(feature.Slug)

	assert.NotNil(t, retrievedFeature)
	assert.Equal(t, feature.Slug, retrievedFeature.Slug)
}

func TestGetBySlug_FeatureNotExists(t *testing.T) {
	setupTestDB()
	service := services.NewFeatureFlippingService()

	retrievedFeature := service.GetBySlug("non-existent-feature")

	assert.NotNil(t, retrievedFeature)
	assert.Equal(t, "", string(retrievedFeature.Slug))
}

func TestList_FeaturesExist(t *testing.T) {
	setupTestDB()
	service := services.NewFeatureFlippingService()

	var allFeatures int64
	database.CurrentDatabase.
		Model(&models.FeatureFlipping{}).
		Count(&allFeatures)

	retrievedFeatures := service.List()

	assert.NotNil(t, retrievedFeatures)
	assert.Equal(t, int(allFeatures), len(retrievedFeatures))
}

func TestEdit_Success(t *testing.T) {
	setupTestDB()
	service := services.NewFeatureFlippingService()

	feature := tests_utils.CreateFeatureFlipping("test-feature", true)

	isEnabled := false
	editData := models.EditFeatureFlipping{
		Enabled: &isEnabled,
	}

	updatedFeature, err := service.Edit(&feature, editData)

	require.NoError(t, err)
	assert.NotNil(t, updatedFeature)
	assert.Equal(t, *editData.Enabled, updatedFeature.Enabled)
}

func TestEdit_ValidationError(t *testing.T) {
	setupTestDB()
	service := services.NewFeatureFlippingService()

	// Create and insert a feature flipping in the test database
	feature := tests_utils.CreateFeatureFlipping("test-feature", true)

	// Create invalid edit data (no fields set)
	editData := models.EditFeatureFlipping{}

	updatedFeature, err := service.Edit(&feature, editData)

	assert.Error(t, err)
	assert.Nil(t, updatedFeature)
}
