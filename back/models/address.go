package models

import "gorm.io/gorm"

type Address struct {
	gorm.Model
	Street    *string
	Number    *string
	City      *string
	Zip       *string
	Latitude  *float64
	Longitude *float64
}
