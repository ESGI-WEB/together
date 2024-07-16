package tests_utils

import "together/models"

func GetAddressCreate() models.AddressCreate {
	return models.AddressCreate{
		Street: "Test St",
		Number: "123 Bis",
		City:   "Testville",
		Zip:    "75001",
	}
}

func GetInvalidAddressCreate() models.AddressCreate {
	return models.AddressCreate{
		Number: "123 Bis",
		City:   "Testville",
		Zip:    "75001",
	}
}
