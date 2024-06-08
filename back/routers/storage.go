package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
)

type StorageRouter struct{}

func (r *StorageRouter) SetupRoutes(e *echo.Echo) {
	storageController := controllers.NewStorageController()

	group := e.Group("/storage")

	group.GET("", storageController.GetImage)
}
