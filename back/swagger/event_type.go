package swagger

import (
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/endpoint"
	"github.com/zc2638/swag/option"
	"net/http"
	"together/controllers"
	"together/models"
)

func SetupEventTypeSwagger() *swag.API {
	api := swag.New(
		option.Title("Event Type API"),
		option.SecurityScheme("bearer_auth", option.APIKeySecurity("Authorization", "header")),
		option.Tag("Event type", "Endpoints related to event type operations"),
	)

	eventTypeController := controllers.NewEventTypeController()

	api.AddEndpoint(
		endpoint.New(
			http.MethodGet, "/event-types",
			endpoint.Handler(eventTypeController.GetAllEventTypes),
			endpoint.Summary("Get all event types"),
			endpoint.Description("Retrieve all event types."),
			endpoint.Response(http.StatusOK, "Successfully retrieved event types", endpoint.SchemaResponseOption([]models.EventType{})),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Event type"),
		),
	)

	api.AddEndpoint(
		endpoint.New(
			http.MethodPost, "/event-types",
			endpoint.Handler(eventTypeController.CreateEventType),
			endpoint.FormData("image", "file", "Image file for the event type", true),
			endpoint.FormData("name", "string", "Name of the event type", true),
			endpoint.FormData("description", "string", "Description of the event type", true),
			endpoint.Summary("Create a new event type"),
			endpoint.Description("Creates a new event type with the provided information."),
			endpoint.Response(http.StatusCreated, "Successfully created event type", endpoint.SchemaResponseOption(models.EventType{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnprocessableEntity, "Validation error"),
			endpoint.Response(http.StatusConflict, "Event type already exists"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Event type"),
		),
	)

	api.AddEndpoint(
		endpoint.New(
			http.MethodPut, "/event-types/{id}",
			endpoint.Handler(eventTypeController.UpdateEventType),
			endpoint.Summary("Update an event type"),
			endpoint.Description("Updates an existing event type with the provided information."),
			endpoint.Path("id", "string", "ID of the event type to update", true),
			endpoint.FormData("name", "string", "Name of the event type", true),
			endpoint.FormData("description", "string", "Description of the event type", true),
			endpoint.FormData("image", "file", "Image file for the event type", false),
			endpoint.Response(http.StatusOK, "Successfully updated event type", endpoint.SchemaResponseOption(models.EventType{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnprocessableEntity, "Validation error"),
			endpoint.Response(http.StatusConflict, "Event type conflict"),
			endpoint.Response(http.StatusNotFound, "Event type not found"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Event type"),
		),
	)

	api.AddEndpoint(
		endpoint.New(
			http.MethodDelete, "/event-types/{id}",
			endpoint.Handler(eventTypeController.DeleteEventType),
			endpoint.Summary("Delete an event type"),
			endpoint.Description("Deletes an existing event type by ID."),
			endpoint.Path("id", "string", "ID of the event type to delete", true),
			endpoint.Response(http.StatusNoContent, "Successfully deleted event type"),
			endpoint.Response(http.StatusForbidden, "Event type has associated events"),
			endpoint.Response(http.StatusNotFound, "Event type not found"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Event type"),
		),
	)

	return api
}
