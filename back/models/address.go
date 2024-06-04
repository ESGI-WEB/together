package models

import "gorm.io/gorm"

type Address struct {
	gorm.Model
	Street    string   `json:"street"`
	Number    string   `json:"number"`
	City      string   `json:"city"`
	Zip       string   `json:"zip"`
	Latitude  *float64 `json:"latitude"`
	Longitude *float64 `json:"longitude"`
}

type AddressCreate struct {
	Street    string   `json:"street" validate:"required"`
	Number    string   `json:"number" validate:"required"`
	City      string   `json:"city" validate:"required"`
	Zip       string   `json:"zip" validate:"required"`
	Latitude  *float64 `json:"latitude"`
	Longitude *float64 `json:"longitude"`
}

func (e AddressCreate) ToAddress() *Address {
	return &Address{
		Street:    e.Street,
		Number:    e.Number,
		City:      e.City,
		Zip:       e.Zip,
		Latitude:  e.Latitude,
		Longitude: e.Longitude,
	}
}
