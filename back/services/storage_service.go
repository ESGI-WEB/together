package services

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/s3"
	"mime/multipart"
	"together/storage"
)

type StorageService struct{}

func NewStorageService() *StorageService {
	return &StorageService{}
}

func (s *StorageService) uploadFile(file multipart.FileHeader, filename string) (*s3.PutObjectOutput, error) {
	src, err := file.Open()
	if err != nil {
		return nil, err
	}
	defer src.Close()

	input := &s3.PutObjectInput{
		Bucket:        storage.AwsBucketName,
		Key:           aws.String(filename),
		Body:          src,
		ContentLength: &file.Size,
	}

	return storage.S3.PutObject(input)
}

func (s *StorageService) getFileUrl(filename string) string {
	return fmt.Sprintf("https://%s.s3.fr-par.scw.cloud/%s", *storage.AwsBucketName, filename)
}

func (s *StorageService) getFileNameFromFullPath(path string) string {
	return path[len(s.getFileUrl("")):]
}

func (s *StorageService) deleteFile(filename string) (*s3.DeleteObjectOutput, error) {
	input := &s3.DeleteObjectInput{
		Bucket: storage.AwsBucketName,
		Key:    aws.String(filename),
	}

	return storage.S3.DeleteObject(input)
}
