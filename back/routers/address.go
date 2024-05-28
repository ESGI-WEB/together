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
	group.POST("", addressController.CreateAddress, func(next echo.HandlerFunc) echo.HandlerFunc {
		return middlewares.AuthenticationMiddleware(next)
	})
}
