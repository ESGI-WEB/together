package swagger

import (
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/endpoint"
	"github.com/zc2638/swag/option"
	"net/http"
	"together/controllers"
	"together/models"
)

func SetupAddressSwagger() *swag.API {
	api := swag.New(
		option.Title("Address API Doc"),
		option.SecurityScheme("bearer_auth",
			option.APIKeySecurity("Authorization", "header"),
		),
	)

	addressController := controllers.NewAddressController()

	api.AddEndpoint(
		endpoint.New(
			http.MethodPost, "/addresses",
			endpoint.Handler(addressController.CreateAddress),
			endpoint.Summary("Create a new address"),
			endpoint.Description("Creates a new address with the provided information."),
			endpoint.Body(models.AddressCreate{}, "Address object that needs to be added", true),
			endpoint.Response(http.StatusCreated, "Successfully created address", endpoint.SchemaResponseOption(models.Address{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnprocessableEntity, "Validation error"),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Security("bearer_auth"),
		),
	)

	return api
}
