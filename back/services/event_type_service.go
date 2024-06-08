package services

import (
	"github.com/go-playground/validator/v10"
	"github.com/gosimple/slug"
	"mime/multipart"
	"together/database"
	"together/models"
	"together/utils"
)

type EventTypeService struct{}

func NewEventTypeService() *EventTypeService {
	return &EventTypeService{}
}

func (s *EventTypeService) GetAllEventTypes() ([]models.EventType, error) {
	var eventTypes []models.EventType
	result := database.CurrentDatabase.
		Order("name asc").
		Find(&eventTypes)
	if result.Error != nil {
		return nil, result.Error
	}
	return eventTypes, nil
}

func (s *EventTypeService) CreateEventType(eventType models.EventType, file multipart.FileHeader) (*models.EventType, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	err := validate.Struct(eventType)
	if err != nil {
		return nil, err
	}

	storageService := NewStorageService()
	imagePath := s.GetEventTypeFilePath(file, eventType)
	_, err = storageService.uploadFile(file, imagePath)
	if err != nil {
		return nil, err
	}
	eventType.ImagePath = storageService.getFileUrl(imagePath)

	result := database.CurrentDatabase.Create(&eventType)
	if result.Error != nil {
		return nil, result.Error
	}

	return &eventType, nil
}

func (s *EventTypeService) UpdateEventType(eventType models.EventType, file *multipart.FileHeader) (*models.EventType, error) {
	validate := validator.New(validator.WithRequiredStructEnabled())
	err := validate.Struct(eventType)
	if err != nil {
		return nil, err
	}

	oldPath := eventType.ImagePath
	storageService := NewStorageService()

	if file != nil {
		filePath := s.GetEventTypeFilePath(*file, eventType)
		_, err = storageService.uploadFile(*file, filePath)
		if err != nil {
			return nil, err
		}
		eventType.ImagePath = storageService.getFileUrl(filePath)
	}

	result := database.CurrentDatabase.Save(&eventType)
	if result.Error != nil {
		return nil, result.Error
	}

	// if path has changed, delete the old image
	// ignore error if unable to delete
	if file != nil && eventType.ImagePath != oldPath {
		_, _ = storageService.deleteFile(storageService.getFileNameFromFullPath(oldPath))
	}

	return &eventType, nil
}

func (s *EventTypeService) DeleteEventType(eventType models.EventType) error {
	err := database.CurrentDatabase.First(&eventType, eventType.ID).Error
	if err != nil {
		return err
	}

	result := database.CurrentDatabase.Delete(&eventType)
	if result.Error != nil {
		return result.Error
	}

	// ignore error if unable to delete
	_, _ = NewStorageService().deleteFile(NewStorageService().getFileNameFromFullPath(eventType.ImagePath))

	return nil
}

func (s *EventTypeService) GetEventTypeFilePath(file multipart.FileHeader, eventType models.EventType) string {
	return `event_types/` + slug.Make(eventType.Name) + utils.GetImageExt(file)
}
