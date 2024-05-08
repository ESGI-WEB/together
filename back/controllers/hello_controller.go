package controllers

import (
	"github.com/labstack/echo/v4"
	"net/http"
	"together/models"
	"together/services"
)

type HelloController struct {
	helloService *services.HelloService
}

func NewHelloController() *HelloController {
	return &HelloController{
		helloService: services.NewHelloService(),
	}
}

func (c *HelloController) Hello(ctx echo.Context) error {
	message := c.helloService.GetHelloMessage()
	return ctx.String(http.StatusOK, message)
}

func (c *HelloController) HelloAdmin(ctx echo.Context) error {
	loggedUser := ctx.Get("user").(models.User)
	message := c.helloService.GetHelloMessage()
	message += " " + loggedUser.Name
	return ctx.String(http.StatusOK, message)
}
