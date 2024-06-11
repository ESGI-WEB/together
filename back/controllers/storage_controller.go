package controllers

import (
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
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.Blob(http.StatusOK, *resp.ContentType, bytes)
}
