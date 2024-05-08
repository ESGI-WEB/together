package utils

import (
	"github.com/go-playground/validator/v10"
)

func GetValidationErrors(errors validator.ValidationErrors, jsonBody interface{}) map[string]string {
	var validationErrors = make(map[string]string)

	for _, e := range errors {
		fieldNameJSON := GetJSONFieldName(jsonBody, e.Field())
		validationErrors[fieldNameJSON] = e.Tag()
	}

	return validationErrors
}
