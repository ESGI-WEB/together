package errors

import "errors"

var ErrUserAlreadyExists = errors.New("user already exists")
var ErrInvalidCredentials = errors.New("invalid credentials")
var ErrInternal = errors.New("internal error")
var ErrUserAlreadyInGroup = errors.New("user already in group")
var ErrCodeDoesNotExist = errors.New("code does not exist")
