package tests

import (
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"testing"
	"together/errors"
	"together/models"
	"together/services"
	"together/tests/tests_utils"
	"together/utils"
)

func TestAddUser_Success(t *testing.T) {
	setupTestDB()
	service := services.NewUserService()

	user := tests_utils.GetValidUser(models.UserRole)

	addedUser, err := service.AddUser(user)

	require.NoError(t, err)
	assert.NotNil(t, addedUser)
	assert.NotZero(t, addedUser.ID)
	assert.Equal(t, user.Name, addedUser.Name)
}

func TestAddUser_DuplicateEmail(t *testing.T) {
	setupTestDB()
	service := services.NewUserService()

	existingUser, _ := tests_utils.CreateUser(models.UserRole)
	user := tests_utils.GetValidUser(models.UserRole)
	user.Email = existingUser.Email

	addedUser, err := service.AddUser(user)

	assert.Error(t, err)
	assert.Nil(t, addedUser)
	assert.Equal(t, errors.ErrUserAlreadyExists, err)
}

func TestGetUsers_Success(t *testing.T) {
	setupTestDB()
	service := services.NewUserService()

	_, _ = tests_utils.CreateUser(models.UserRole)
	_, _ = tests_utils.CreateUser(models.UserRole)

	pagination := utils.Pagination{Limit: 10, Page: 1}
	users, err := service.GetUsers(pagination, nil)

	require.NoError(t, err)
	assert.NotNil(t, users)
}

func TestDeleteUser_Success(t *testing.T) {
	setupTestDB()
	service := services.NewUserService()

	user, _ := tests_utils.CreateUser(models.UserRole)

	err := service.DeleteUser(user.ID)

	require.NoError(t, err)

	_, err = service.FindByID(user.ID)
	assert.Error(t, err)
	assert.Equal(t, errors.ErrNotFound, err)
}

func TestUpdateUser_Success(t *testing.T) {
	setupTestDB()
	service := services.NewUserService()

	user, _ := tests_utils.CreateUser(models.UserRole)
	newName := "Updated Name"
	user.Name = newName

	updatedUser, err := service.UpdateUser(user.ID, *user)

	require.NoError(t, err)
	assert.NotNil(t, updatedUser)
	assert.Equal(t, newName, updatedUser.Name)
}

func TestUpdateUser_DuplicateEmail(t *testing.T) {
	setupTestDB()
	service := services.NewUserService()

	user1, _ := tests_utils.CreateUser(models.UserRole)
	user2, _ := tests_utils.CreateUser(models.UserRole)
	user2.Email = user1.Email

	_, err := service.UpdateUser(user2.ID, *user2)

	assert.Error(t, err)
	assert.Equal(t, errors.ErrUserAlreadyExists, err)
}

func TestFindByID_Success(t *testing.T) {
	setupTestDB()
	service := services.NewUserService()

	user, _ := tests_utils.CreateUser(models.UserRole)

	foundUser, err := service.FindByID(user.ID)

	require.NoError(t, err)
	assert.NotNil(t, foundUser)
	assert.Equal(t, user.ID, foundUser.ID)
}
