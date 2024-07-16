package routers

import (
	"github.com/labstack/echo/v4"
	"together/controllers"
	"together/middlewares"
)

type AddressRouter struct{}

func (r *AddressRouter) SetupRoutes(e *echo.Echo) {
	addressController := controllers.NewAddressController()

	group := e.Group("/addresses")

	group.POST("", addressController.CreateAddress, middlewares.AuthenticationMiddleware())
}
