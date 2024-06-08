package swagger

import (
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/endpoint"
	"github.com/zc2638/swag/option"
	"net/http"
	"together/controllers"
	"together/models"
)

func SetupEventSwagger() *swag.API {
	api := swag.New(
		option.Title("Event API Doc"),
		option.Security("event_auth", "read:events"),
		option.SecurityScheme("event_auth",
			option.OAuth2Security("accessCode", "http://example.com/oauth/authorize", "http://example.com/oauth/token"),
			option.OAuth2Scope("write:events", "modify events in your account"),
			option.OAuth2Scope("read:events", "read your events"),
		),
	)

	eventController := controllers.NewEventController()

	api.AddEndpoint(
		endpoint.New(
			http.MethodPost, "/events",
			endpoint.Handler(eventController.CreateEvent),
			endpoint.Summary("Create a new event"),
			endpoint.Description("Creates a new event with the provided information."),
			endpoint.Body(models.EventCreate{}, "Event object that needs to be added", true),
			endpoint.Response(http.StatusCreated, "Successfully created event", endpoint.SchemaResponseOption(models.Event{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnprocessableEntity, "Validation error"),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
		),
		endpoint.New(
			http.MethodGet, "/events/{id}",
			endpoint.Handler(eventController.GetEvent),
			endpoint.Summary("Get event by ID"),
			endpoint.Description("Returns the event identified by the provided ID."),
			endpoint.Path("id", "integer", "ID of the event to return", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved event", endpoint.SchemaResponseOption(models.Event{})),
			endpoint.Response(http.StatusNotFound, "Event not found"),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
		),
		endpoint.New(
			http.MethodGet, "/events/{id}/attends",
			endpoint.Handler(eventController.GetEventAttends),
			endpoint.Summary("Get attends for event"),
			endpoint.Description("Returns the list of users attending the event identified by the provided ID."),
			endpoint.Path("id", "integer", "ID of the event", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved attends", endpoint.SchemaResponseOption([]models.Attend{})),
			endpoint.Response(http.StatusNotFound, "Event not found"),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
		),
	)

	return api
}
