package tests

import (
	"testing"
	"together/database"
	"together/models"
	"together/services"

	"github.com/stretchr/testify/assert"
)

func TestAddAddress_Success(t *testing.T) {
	service := services.NewAddressService()

	addressCreate := models.AddressCreate{
		Street: "Test St",
		Number: "123 Bis",
		City:   "Testville",
		Zip:    "75001",
	}

	address, err := service.AddAddress(addressCreate)

	assert.NoError(t, err)
	assert.NotNil(t, address)
	assert.Equal(t, addressCreate.Street, address.Street)
	assert.Equal(t, addressCreate.Number, address.Number)
	assert.Equal(t, addressCreate.City, address.City)
	assert.Equal(t, addressCreate.Zip, address.Zip)
}

func TestAddAddress_ValidationError(t *testing.T) {
	setupTestDB()
	service := services.NewAddressService()

	addressCreate := models.AddressCreate{
		Number: "123 Bis",
		City:   "Testville",
		Zip:    "75001",
	}

	address, err := service.AddAddress(addressCreate)

	assert.Error(t, err)
	assert.Nil(t, address)
}

func TestAddAddress_DatabaseError(t *testing.T) {
	setupTestDB()
	service := services.NewAddressService()

	// Close the database to simulate a database error
	db, _ := database.CurrentDatabase.DB()
	_ = db.Close()

	addressCreate := models.AddressCreate{
		Street: "Test St",
		Number: "123 Bis",
		City:   "Testville",
		Zip:    "75001",
	}

	address, err := service.AddAddress(addressCreate)

	assert.Error(t, err)
	assert.Nil(t, address)
}
