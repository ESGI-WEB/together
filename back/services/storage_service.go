package services

import (
	"fmt"
	"github.com/gosimple/slug"
	"io"
	"mime/multipart"
	"os"
	"together/utils"
)

type StorageService struct{}

func NewStorageService() *StorageService {
	return &StorageService{}
}

func (s *StorageService) SaveFile(file multipart.FileHeader, name string) (string, error) {
	src, err := file.Open()
	if err != nil {
		return "", err
	}
	defer src.Close()

	// Create a destination file
	extension := utils.GetImageExt(file)
	filePath := fmt.Sprintf("storage/images/%s%s", slug.Make(name), extension)
	dst, err := os.Create(filePath)
	if err != nil {
		return "", err
	}
	defer dst.Close()

	// Copy the file content
	if _, err = io.Copy(dst, src); err != nil {
		return "", err
	}

	return filePath, nil
}

func (s *StorageService) DeleteFile(filePath string) error {
	err := os.Remove(filePath)
	if err != nil {
		return err
	}
	return nil
}
