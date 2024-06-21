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

	api.AddEndpoint(
		endpoint.New(
			http.MethodGet, "/users",
			endpoint.Handler(userController.GetUsers),
			endpoint.Summary("Get all users"),
			endpoint.Description("Retrieve all users."),
			endpoint.Query("page", "integer", "Page number", false),
			endpoint.Query("limit", "integer", "Number of items per page", false),
			endpoint.Query("sort", "string", "Sort column and order like name asc", false),
			endpoint.Response(http.StatusOK, "Successfully retrieved users", endpoint.SchemaResponseOption([]models.User{})),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("User"),
		),
	)

	api.AddEndpoint(
		endpoint.New(
			http.MethodDelete, "/users/{id}",
			endpoint.Handler(userController.DeleteUser),
			endpoint.Summary("Delete a user"),
			endpoint.Description("Deletes a user identified by the provided ID."),
			endpoint.Path("id", "integer", "ID of the user to delete", true),
			endpoint.Response(http.StatusNoContent, "Successfully deleted user"),
			endpoint.Response(http.StatusNotFound, "User not found"),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Response(http.StatusForbidden, "User not authorized to delete user"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("User"),
		),
	)

	api.AddEndpoint(
		endpoint.New(
			http.MethodPut, "/users/{id}",
			endpoint.Handler(userController.UpdateUser),
			endpoint.Summary("Update a user"),
			endpoint.Description("Updates a user identified by the provided ID."),
			endpoint.Path("id", "integer", "ID of the user to update", true),
			endpoint.Body(models.User{}, "User object with updated information", true),
			endpoint.Response(http.StatusOK, "Successfully updated user", endpoint.SchemaResponseOption(models.User{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnprocessableEntity, "Validation error"),
			endpoint.Response(http.StatusNotFound, "User not found"),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Response(http.StatusForbidden, "User not authorized to update user"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("User"),
		),
	)

	return api
}
