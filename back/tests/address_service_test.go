package tests

import (
	"testing"
	"together/services"
	"together/tests/tests_utils"

	"github.com/stretchr/testify/assert"
)

func TestAddAddress_Success(t *testing.T) {
	service := services.NewAddressService()

	addressCreate := tests_utils.GetAddressCreate()

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

	addressCreate := tests_utils.GetInvalidAddressCreate()

	address, err := service.AddAddress(addressCreate)

	assert.Error(t, err)
	assert.Nil(t, address)
}
