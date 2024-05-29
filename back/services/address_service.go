package services

import (
	"github.com/go-playground/validator/v10"
	"together/database"
	"together/models"
)

type AddressService struct{}

func NewAddressService() *AddressService {
	return &AddressService{}
}

func (s *AddressService) AddAddress(address models.AddressCreate) (*models.Address, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	err := validate.Struct(address)
	if err != nil {
		return nil, err
	}

	newAddress := address.ToAddress()
	create := database.CurrentDatabase.Create(&newAddress)
	if create.Error != nil {
		return nil, create.Error
	}

	return newAddress, nil
}
