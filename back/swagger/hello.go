package swagger

import (
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/endpoint"
	"github.com/zc2638/swag/option"
	"net/http"
	"together/controllers"
)

func SetupHelloSwagger() *swag.API {
	api := swag.New(
		option.Title("Hello API Doc"),
		option.SecurityScheme("bearer_auth",
			option.APIKeySecurity("Authorization", "header"),
		),
		option.Tag("Hello", "Endpoints related to check if api working well and say hello"),
	)

	helloController := controllers.NewHelloController()

	api.AddEndpoint(
		endpoint.New(
			http.MethodGet, "/hello",
			endpoint.Handler(helloController.Hello),
			endpoint.Summary("Say hello"),
			endpoint.Description("Returns a hello message."),
			endpoint.Response(http.StatusOK, "Successfully retrieved hello message", endpoint.SchemaResponseOption("string")),
			endpoint.Tags("Hello"),
		),
		endpoint.New(
			http.MethodGet, "/hello/admin",
			endpoint.Handler(helloController.HelloAdmin),
			endpoint.Summary("Say hello to admin"),
			endpoint.Description("Returns a hello message to admin."),
			endpoint.Response(http.StatusOK, "Successfully retrieved hello message", endpoint.SchemaResponseOption("string")),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Hello"),
		),
	)

	return api
}
