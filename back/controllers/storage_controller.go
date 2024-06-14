package controllers

import (
	"errors"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/labstack/echo/v4"
	"net/http"
	"together/services"
)

type StorageController struct {
	storageService *services.StorageService
}

func NewStorageController() *StorageController {
	return &StorageController{}
}

func (c *StorageController) GetImage(ctx echo.Context) error {
	path := ctx.Param("path")
	bytes, resp, err := c.storageService.GetImageFromS3(path)
	if err != nil {
		var awsErr s3.RequestFailure
		if errors.As(err, &awsErr) && awsErr.StatusCode() == 404 {
			return ctx.NoContent(http.StatusNotFound)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.Blob(http.StatusOK, *resp.ContentType, bytes)
}
