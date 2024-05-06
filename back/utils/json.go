package utils

import "reflect"

func GetJSONFieldName(obj interface{}, fieldName string) string {
	objType := reflect.TypeOf(obj)

	for i := 0; i < objType.NumField(); i++ {
		field := objType.Field(i)
		jsonTag := field.Tag.Get("json")
		if field.Name == fieldName {
			return jsonTag
		}
	}

	return fieldName
}