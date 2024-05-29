package utils

import (
	"github.com/go-playground/validator/v10"
	"reflect"
	"strings"
)

func GetValidationErrors(errors validator.ValidationErrors, jsonBody interface{}) map[string]string {
	var validationErrors = make(map[string]string)

	for _, e := range errors {
		fieldParts := strings.Split(e.StructNamespace(), ".")[1:]
		currentBody := jsonBody
		fieldNameJSON := GetJSONFieldName(currentBody, fieldParts[0])

		// Traverse the jsonBody to get to the nested struct
		for i := 0; i < len(fieldParts)-1; i++ {
			currentBody = getField(currentBody, fieldParts[i])
			if currentBody == nil {
				break
			}

			if currentBody != nil {
				fieldNameJSON += "." + GetJSONFieldName(currentBody, fieldParts[len(fieldParts)-1])
			}
		}

		if fieldNameJSON != "" {
			validationErrors[fieldNameJSON] = e.Tag()
		}
	}

	return validationErrors
}

func getField(jsonBody interface{}, fieldName string) interface{} {
	v := reflect.ValueOf(jsonBody)
	if v.Kind() == reflect.Ptr {
		v = v.Elem()
	}

	if v.Kind() != reflect.Struct {
		return nil
	}

	field := v.FieldByName(fieldName)
	if !field.IsValid() {
		return nil
	}

	return field.Interface()
}
