package services

import (
	"github.com/go-playground/validator/v10"
	"github.com/labstack/gommon/random"
	"strconv"
	"together/database"
	"together/errors"
	"together/models"
	"together/utils"
)

type UserService struct{}

func NewUserService() *UserService {
	return &UserService{}
}

func (s *UserService) AddUser(user models.User) (*models.User, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	err := validate.Struct(user)
	if err != nil {
		return nil, err
	}

	var existingUser models.User
	database.CurrentDatabase.Where("email = ?", user.Email).First(&existingUser)
	if existingUser.ID != 0 {
		return nil, errors.ErrUserAlreadyExists
	}

	user.Password, err = NewSecurityService().HashPassword(*user.PlainPassword)
	if err != nil {
		return nil, err
	}
	user.PlainPassword = nil

	if user.ColorHex == "" {
		user.ColorHex = s.GenerateAvatarColorHex()
	}

	create := database.CurrentDatabase.Create(&user)
	if create.Error != nil {
		return nil, create.Error
	}

	return &user, nil
}

func (s *UserService) GenerateAvatarColorHex() string {
	color := "#" + random.String(6, "0123456789ABCDEF")
	return color
}

func (s *UserService) GetUsers(pagination utils.Pagination, search *string) (*utils.Pagination, error) {
	var users []models.User
	query := database.CurrentDatabase

	if search != nil && *search != "" {
		searchedId, _ := strconv.Atoi(*search)

		query = query.Where(
			query.Where("id = ?", searchedId).
				Or("LOWER(name) LIKE LOWER(?)", "%"+*search+"%").
				Or("LOWER(email) LIKE LOWER(?)", "%"+*search+"%"))
	}

	query.Scopes(utils.Paginate(users, &pagination, query)).
		Order("ID asc").
		Find(&users)
	pagination.Rows = users

	return &pagination, nil
}

func (s *UserService) DeleteUser(id uint) error {
	user := models.User{}
	database.CurrentDatabase.First(&user, id)
	if user.ID == 0 {
		return errors.ErrNotFound
	}

	// it's using safe delete
	err := database.CurrentDatabase.Delete(&user).Error
	if err != nil {
		return err
	}

	return nil
}

func (s *UserService) UpdateUser(id uint, user models.User) (*models.User, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	err := validate.Struct(user)
	if err != nil {
		return nil, err
	}

	// check if user exists if changed email
	var existingUser models.User
	database.CurrentDatabase.Where("email = ?", user.Email).First(&existingUser)
	if existingUser.ID != 0 && existingUser.ID != id {
		return nil, errors.ErrUserAlreadyExists
	}

	if user.PlainPassword != nil {
		user.Password, err = NewSecurityService().HashPassword(*user.PlainPassword)
		if err != nil {
			return nil, err
		}
		user.PlainPassword = nil
	}

	err = database.CurrentDatabase.Save(&user).Error
	if err != nil {
		return nil, err
	}

	return &user, nil
}

func (s *UserService) FindByID(id uint) (*models.User, error) {
	var user models.User
	database.CurrentDatabase.First(&user, id)
	if user.ID == 0 {
		return nil, errors.ErrNotFound
	}

	return &user, nil
}
