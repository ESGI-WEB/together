package utils

import (
	"fmt"
	"github.com/go-playground/validator/v10"
	"reflect"
	"strings"
)

func GetValidationErrors(errors validator.ValidationErrors, jsonBody interface{}) map[string]string {
	var validationErrors = make(map[string]string)

	for _, e := range errors {
		fmt.Println(e.StructNamespace())
		fieldParts := strings.Split(e.StructNamespace(), ".")
		fieldPartsWithoutNamespace := fieldParts
		if len(fieldParts) > 1 {
			fieldPartsWithoutNamespace = fieldParts[1:]
		}
		currentBody := jsonBody
		fieldNameJSON := GetJSONFieldName(currentBody, fieldPartsWithoutNamespace[0])

		for i := 0; i < len(fieldPartsWithoutNamespace)-1; i++ {
			currentBody = getField(currentBody, fieldPartsWithoutNamespace[i])
			if currentBody == nil {
				break
			}

			if currentBody != nil {
				fieldNameJSON += "." + GetJSONFieldName(currentBody, fieldPartsWithoutNamespace[len(fieldPartsWithoutNamespace)-1])
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
