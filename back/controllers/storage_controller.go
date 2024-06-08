package controllers

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/labstack/echo/v4"
	"io"
	"net/http"
	"together/storage"
)

type StorageController struct {
}

func NewStorageController() *StorageController {
	return &StorageController{}
}

func (c *StorageController) GetImage(ctx echo.Context) error {
	filename := ctx.QueryParam("filename")
	if filename == "" {
		return ctx.String(http.StatusBadRequest, "filename is required")
	}

	input := &s3.GetObjectInput{
		Bucket: storage.AwsBucketName,
		Key:    aws.String(filename),
	}

	resp, err := storage.S3.GetObject(input)
	defer func(Body io.ReadCloser) {
		err := Body.Close()
		if err != nil {
			ctx.Logger().Error("Cannot close S3 object")
		}
	}(resp.Body)

	bytes, err := io.ReadAll(resp.Body)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.Blob(http.StatusOK, *resp.ContentType, bytes)
}
