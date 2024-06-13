package swagger

import (
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/endpoint"
	"github.com/zc2638/swag/option"
	"net/http"
	"together/controllers"
	"together/models"
)

func SetupUserSwagger() *swag.API {
	api := swag.New(
		option.Title("User API Documentation"),
		option.SecurityScheme("bearer_auth",
			option.APIKeySecurity("Authorization", "header"),
		),
		option.Tag("User", "Endpoints related to user operations"),
	)

	userController := controllers.NewUserController()

	api.AddEndpoint(
		endpoint.New(
			http.MethodPost, "/users",
			endpoint.Handler(userController.CreateUser),
			endpoint.Summary("Create a new user"),
			endpoint.Description("Creates a new user with the provided information."),
			endpoint.Body(models.User{}, "User object that needs to be added", true),
			endpoint.Response(http.StatusCreated, "Successfully created user", endpoint.SchemaResponseOption(models.User{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusConflict, "User already exists"),
			endpoint.Response(http.StatusUnprocessableEntity, "Validation error"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Tags("User"),
		),
	)

	return api
}
