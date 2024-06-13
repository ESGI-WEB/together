package services

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/s3"
	"io"
	"mime/multipart"
	"together/storage"
)

type StorageService struct{}

func NewStorageService() *StorageService {
	return &StorageService{}
}

func (s *StorageService) UploadFile(file multipart.FileHeader, filename string) (*s3.PutObjectOutput, error) {
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

// GetFileApiUrl from where the image can be accessed if called from the frontend with the endpoint
// e.g. /storage/abc/def/image.jpg called from the frontend as http://example.com/storage/abc/def/image.jpg
func (s *StorageService) GetFileApiUrl(filename string) string {
	return fmt.Sprintf("storage/%s", filename)
}

func (s *StorageService) GetFileNameFromFullPath(path string) string {
	return path[len(s.GetFileApiUrl("")):]
}

func (s *StorageService) DeleteFile(filename string) (*s3.DeleteObjectOutput, error) {
	input := &s3.DeleteObjectInput{
		Bucket: storage.AwsBucketName,
		Key:    aws.String(filename),
	}

	return storage.S3.DeleteObject(input)
}

func (s *StorageService) GetImageFromS3(filename string) ([]byte, *s3.GetObjectOutput, error) {
	input := &s3.GetObjectInput{
		Bucket: storage.AwsBucketName,
		Key:    aws.String(filename),
	}

	resp, err := storage.S3.GetObject(input)
	if err != nil {
		return nil, nil, err
	}

	defer func(Body io.ReadCloser) {
		_ = Body.Close()
	}(resp.Body)

	bytes, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, nil, err
	}

	return bytes, resp, nil
}
