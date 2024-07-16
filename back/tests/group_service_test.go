package tests

import (
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"testing"
	"together/database"
	"together/models"
	"together/services"
	"together/tests/tests_utils"
	"together/utils"
)

func TestCreateGroup_Success(t *testing.T) {
	setupTestDB()
	service := services.NewGroupService()

	group := tests_utils.GetValidGroup()

	createdGroup, err := service.CreateGroup(group)

	require.NoError(t, err)
	assert.NotNil(t, createdGroup)
	assert.Equal(t, group.Name, createdGroup.Name)
}

func TestCreateGroup_ValidationError(t *testing.T) {
	setupTestDB()
	service := services.NewGroupService()

	group := tests_utils.GetInvalidGroup()

	createdGroup, err := service.CreateGroup(group)

	assert.Error(t, err)
	assert.Nil(t, createdGroup)
}

func TestGetGroupById_Success(t *testing.T) {
	setupTestDB()
	service := services.NewGroupService()

	group := tests_utils.CreateGroup()

	retrievedGroup, err := service.GetGroupById(group.ID)

	require.NoError(t, err)
	assert.NotNil(t, retrievedGroup)
	assert.Equal(t, group.ID, retrievedGroup.ID)
}

func TestGetGroupById_NotFound(t *testing.T) {
	setupTestDB()
	service := services.NewGroupService()

	retrievedGroup, err := service.GetGroupById(9999)

	assert.Error(t, err)
	assert.Nil(t, retrievedGroup)
}

func TestGetAllMyGroups_Success(t *testing.T) {
	setupTestDB()
	service := services.NewGroupService()

	group := tests_utils.CreateGroup()

	pagination := utils.Pagination{Limit: 10, Page: 1}
	groups, err := service.GetAllMyGroups(group.OwnerID, pagination)

	require.NoError(t, err)
	assert.NotNil(t, groups)
}

func TestJoinGroup_Success(t *testing.T) {
	setupTestDB()
	service := services.NewGroupService()

	group := tests_utils.CreateGroup()
	user, _ := tests_utils.CreateUser(models.UserRole)

	joinedGroup, err := service.JoinGroup(group.Code, *user)

	require.NoError(t, err)
	assert.NotNil(t, joinedGroup)
	assert.Equal(t, group.ID, joinedGroup.ID)
}

func TestJoinGroup_AlreadyMember(t *testing.T) {
	setupTestDB()
	service := services.NewGroupService()

	group := tests_utils.CreateGroup()
	var groupOwner models.User
	database.CurrentDatabase.Find(&groupOwner, group.OwnerID)

	joinedGroup, err := service.JoinGroup(group.Code, groupOwner)

	assert.Error(t, err)
	assert.Nil(t, joinedGroup)
}

func TestIsUserInGroup_Success(t *testing.T) {
	setupTestDB()
	service := services.NewGroupService()

	group := tests_utils.CreateGroup()

	isInGroup, err := service.IsUserInGroup(group.OwnerID, group.ID)

	require.NoError(t, err)
	assert.True(t, isInGroup)
}

func TestIsUserInGroup_NotInGroup(t *testing.T) {
	setupTestDB()
	service := services.NewGroupService()

	group := tests_utils.CreateGroup()
	newUser, _ := tests_utils.CreateUser(models.UserRole)

	isInGroup, err := service.IsUserInGroup(newUser.ID, group.ID)

	require.NoError(t, err)
	assert.False(t, isInGroup)
}

func TestIsUserInGroup_UserNotFound(t *testing.T) {
	setupTestDB()
	service := services.NewGroupService()

	group := tests_utils.CreateGroup()

	isInGroup, err := service.IsUserInGroup(0, group.ID)

	assert.NoError(t, err)
	assert.False(t, isInGroup)
}

func TestGetNextEvent_NoEvent(t *testing.T) {
	setupTestDB()
	service := services.NewGroupService()

	group := tests_utils.CreateGroup()

	nextEvent, err := service.GetNextEvent(group.ID)

	require.NoError(t, err)
	assert.Nil(t, nextEvent)
}

func TestGetAllGroups_Success(t *testing.T) {
	setupTestDB()
	service := services.NewGroupService()

	_ = tests_utils.CreateGroup()

	pagination := utils.Pagination{Limit: 10, Page: 1}
	groups, err := service.GetAllGroups(pagination)

	require.NoError(t, err)
	assert.NotNil(t, groups)
}
