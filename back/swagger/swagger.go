package swagger

import (
	"net/http"
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/endpoint"
	"github.com/zc2638/swag/option"
	"together/controllers"
	"together/models"
)

func SetupSwagger() *swag.API {
	api := swag.New(
		option.Title("Example API Doc"),
		option.Security("petstore_auth", "read:pets"),
		option.SecurityScheme("petstore_auth",
			option.OAuth2Security("accessCode", "http://example.com/oauth/authorize", "http://example.com/oauth/token"),
			option.OAuth2Scope("write:pets", "modify pets in your account"),
			option.OAuth2Scope("read:pets", "read your pets"),
		),
	)

	groupController := controllers.NewGroupController()

	api.AddEndpoint(
		endpoint.New(
			http.MethodPost, "/group",
			endpoint.Handler(groupController.CreateGroup),
			endpoint.Summary("Create a new group"),
			endpoint.Description("Creates a new group with the provided information."),
			endpoint.Body(models.Group{}, "Group object that needs to be added", true),
			endpoint.Response(http.StatusCreated, "Successfully created group", endpoint.SchemaResponseOption(models.Group{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnprocessableEntity, "Validation error"),
		),
		endpoint.New(
			http.MethodGet, "/group/{id}",
			endpoint.Handler(groupController.GetGroupById),
			endpoint.Summary("Get group by ID"),
			endpoint.Description("Returns the group identified by the provided ID."),
			endpoint.Path("id", "integer", "ID of the group to return", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved group", endpoint.SchemaResponseOption(models.Group{})),
			endpoint.Response(http.StatusNotFound, "Group not found"),
		),
		endpoint.New(
			http.MethodGet, "/groups/mine",
			endpoint.Handler(groupController.GetAllMyGroups),
			endpoint.Summary("Get all my groups"),
			endpoint.Description("Returns all groups the authenticated user is part of."),
			endpoint.Response(http.StatusOK, "Successfully retrieved groups", endpoint.SchemaResponseOption([]models.Group{})),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
		),
		endpoint.New(
			http.MethodPost, "/group/join",
			endpoint.Handler(groupController.JoinGroup),
			endpoint.Summary("Join a group"),
			endpoint.Description("Allows the authenticated user to join a group using a group code."),
			endpoint.Body(models.JoinGroupRequest{}, "Join group request", true),
			endpoint.Response(http.StatusOK, "Successfully joined group"),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnprocessableEntity, "Validation error"),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
		),
		endpoint.New(
			http.MethodGet, "/group/{id}/next-event",
			endpoint.Handler(groupController.GetNextEvent),
			endpoint.Summary("Get next event for group"),
			endpoint.Description("Returns the next event for the group identified by the provided ID."),
			endpoint.Path("id", "integer", "ID of the group", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved next event", endpoint.SchemaResponseOption(models.Event{})), // Assuming models.Event exists
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
		),
	)

	return api
}