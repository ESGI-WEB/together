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
		option.Title("Message API Doc"),
		option.SecurityScheme("bearer_auth",
			option.APIKeySecurity("Authorization", "header"),
		),
		option.Tag("Hello", "Endpoints related to check if api working well and say hello"),
	)

	messageController := controllers.NewMessageController()

	api.AddEndpoint(
		endpoint.New(
			http.MethodPost, "/messages/{id}/reaction",
			endpoint.Handler(messageController.CreateReaction),
			endpoint.Summary("Create a reaction"),
			endpoint.Description("Returns a message reaction."),
			endpoint.Path("id", "integer", "ID of the message to react to", true),
			endpoint.Body(models.CreateMessageReaction{}, "Message reaction to be created", true),
			endpoint.Response(http.StatusOK, "Successfully created the message reaction", endpoint.SchemaResponseOption("string")),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Response(http.StatusBadRequest, "Bad request"),
			endpoint.Response(http.StatusInternalServerError, "Unhandled error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Reaction"),
		),
	)

	return api
}
