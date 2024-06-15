package swagger

import (
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/endpoint"
	"github.com/zc2638/swag/option"
	"net/http"
	"together/controllers"
	"together/models"
)

func SetupMessageSwagger() *swag.API {
	api := swag.New(
		option.Title("Message API Documentation"),
		option.SecurityScheme("bearer_auth",
			option.APIKeySecurity("Authorization", "header"),
		),
		option.Tag("Message", "Endpoints related to message operations"),
	)

	messageController := controllers.NewMessageController()

	api.AddEndpoint(
		endpoint.New(
			http.MethodPost, "/messages/publication",
			endpoint.Handler(messageController.CreatePublication),
			endpoint.Summary("Create a new publication"),
			endpoint.Description("Creates a new publication with the provided information."),
			endpoint.Body(models.MessageCreate{}, "Message object that needs to be added", true),
			endpoint.Response(http.StatusCreated, "Successfully created publication", endpoint.SchemaResponseOption(models.Message{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnauthorized, "User unauthorized"),
			endpoint.Response(http.StatusUnprocessableEntity, "Validation error"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Message"),
		),
	)

	api.AddEndpoint(
		endpoint.New(
			http.MethodPut, "/messages/{id}",
			endpoint.Handler(messageController.UpdateMessage),
			endpoint.Summary("Update a message"),
			endpoint.Description("Updates an existing message with the provided information."),
			endpoint.Path("id", "integer", "ID of the message to update", true),
			endpoint.Body(models.MessageUpdate{}, "Message object with updated data", true),
			endpoint.Response(http.StatusOK, "Successfully updated message", endpoint.SchemaResponseOption(models.Message{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnauthorized, "User unauthorized"),
			endpoint.Response(http.StatusNotFound, "Message not found"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Message"),
		),
	)

	api.AddEndpoint(
		endpoint.New(
			http.MethodDelete, "/messages/{id}",
			endpoint.Handler(messageController.DeleteMessage),
			endpoint.Summary("Delete a message"),
			endpoint.Description("Deletes an existing message by ID."),
			endpoint.Path("id", "integer", "ID of the message to delete", true),
			endpoint.Response(http.StatusNoContent, "Successfully deleted message"),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnauthorized, "User unauthorized"),
			endpoint.Response(http.StatusNotFound, "Message not found"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Message"),
		),
	)

	api.AddEndpoint(
		endpoint.New(
			http.MethodPost, "/messages/{id}/pin",
			endpoint.Handler(messageController.PinMessage),
			endpoint.Summary("Pin or unpin a message"),
			endpoint.Description("Pins or unpins an existing message by ID."),
			endpoint.Path("id", "integer", "ID of the message to pin/unpin", true),
			endpoint.Body(models.MessagePinned{}, "Pin status", true),
			endpoint.Response(http.StatusOK, "Successfully pinned/unpinned message", endpoint.SchemaResponseOption(models.Message{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnauthorized, "User unauthorized"),
			endpoint.Response(http.StatusNotFound, "Message not found"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Message"),
		),
	)

	api.AddEndpoint(
		endpoint.New(
			http.MethodGet, "/messages/group/{groupId}/event/{eventId}",
			endpoint.Handler(messageController.GetPublicationsByEventAndGroup),
			endpoint.Summary("Get publications by event and group"),
			endpoint.Description("Gets all publications for a specific event and group."),
			endpoint.Path("groupId", "integer", "ID of the group", true),
			endpoint.Path("eventId", "integer", "ID of the event", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved publications", endpoint.SchemaResponseOption([]models.Message{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnauthorized, "User unauthorized"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Message"),
		),
	)

	api.AddEndpoint(
		endpoint.New(
			http.MethodGet, "/messages/group/{groupId}",
			endpoint.Handler(messageController.GetPublicationsByGroup),
			endpoint.Summary("Get publications by group"),
			endpoint.Description("Gets all publications for a specific group."),
			endpoint.Path("groupId", "integer", "ID of the group", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved publications", endpoint.SchemaResponseOption([]models.Message{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnauthorized, "User unauthorized"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Message"),
		),
	)

	return api
}
