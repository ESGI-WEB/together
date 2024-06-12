package swagger

import (
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/endpoint"
	"github.com/zc2638/swag/option"
	"net/http"
	"together/controllers"
	"together/models"
)

func SetupGroupSwagger() *swag.API {
	api := swag.New(
		option.Title("Group API Doc"),
		option.SecurityScheme("bearer_auth",
			option.APIKeySecurity("Authorization", "header"),
		),
		option.Tag("Group", "Endpoints related to group operations"),
	)

	groupController := controllers.NewGroupController()

	api.AddEndpoint(
		endpoint.New(
			http.MethodPost, "/groups",
			endpoint.Handler(groupController.CreateGroup),
			endpoint.Summary("Create a new group"),
			endpoint.Description("Creates a new group with the provided information."),
			endpoint.Body(models.Group{}, "Group object that needs to be added", true),
			endpoint.Response(http.StatusCreated, "Successfully created group", endpoint.SchemaResponseOption(models.Group{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnprocessableEntity, "Validation error"),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Group"),
		),
		endpoint.New(
			http.MethodGet, "/groups/{id}",
			endpoint.Handler(groupController.GetGroupById),
			endpoint.Summary("Get group by ID"),
			endpoint.Description("Returns the group identified by the provided ID."),
			endpoint.Path("id", "integer", "ID of the group to return", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved group", endpoint.SchemaResponseOption(models.Group{})),
			endpoint.Response(http.StatusNotFound, "Group not found"),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Group"),
		),
		endpoint.New(
			http.MethodGet, "/groups",
			endpoint.Handler(groupController.GetAllMyGroups),
			endpoint.Summary("Get all groups the current user belongs to"),
			endpoint.Description("Returns a list of all groups the current user belongs to."),
			endpoint.Response(http.StatusOK, "Successfully retrieved groups", endpoint.SchemaResponseOption([]models.Group{})),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Group"),
		),
		endpoint.New(
			http.MethodPost, "/groups/join",
			endpoint.Handler(groupController.JoinGroup),
			endpoint.Summary("Join a group"),
			endpoint.Description("Joins the group identified by the provided code."),
			endpoint.Body(models.JoinGroupRequest{}, "Request body to join a group", true),
			endpoint.Response(http.StatusCreated, "Successfully joined group", endpoint.SchemaResponseOption(models.Group{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusConflict, "User already in group"),
			endpoint.Response(http.StatusNotFound, "Group not found"),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Response(http.StatusUnprocessableEntity, "Validation error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Group"),
		),
		endpoint.New(
			http.MethodGet, "/groups/{id}/next-event",
			endpoint.Handler(groupController.GetNextEvent),
			endpoint.Summary("Get next event for a group"),
			endpoint.Description("Returns the next event for the group identified by the provided ID."),
			endpoint.Path("id", "integer", "ID of the group to get the next event for", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved next event", endpoint.SchemaResponseOption(models.Event{})),
			endpoint.Response(http.StatusBadRequest, "Invalid ID format"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Group"),
		),
	)

	return api
}
