package swagger

import (
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/endpoint"
	"github.com/zc2638/swag/option"
	"net/http"
	"together/controllers"
	"together/models"
)

func SetupSecuritySwagger() *swag.API {
	api := swag.New(
		option.Title("Security API Doc"),
		option.Description("API documentation for security endpoints, including user login."),
		option.Security("basic_auth", "read:login"),
		option.SecurityScheme("bearer auth", option.BasicSecurity()),
		option.Tag("Security", "Endpoints related to security operations"),
	)

	securityController := controllers.NewSecurityController()

	api.AddEndpoint(
		endpoint.New(
			http.MethodPost, "/security/login",
			endpoint.Handler(securityController.Login),
			endpoint.Summary("User Login"),
			endpoint.Description("Logs in a user and returns a JWT token."),
			endpoint.Body(models.UserLogin{}, "User login credentials", true),
			endpoint.Response(http.StatusOK, "Successfully logged in", endpoint.SchemaResponseOption(models.LoginResponse{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnprocessableEntity, "Validation error"),
			endpoint.Response(http.StatusUnauthorized, "Invalid credentials"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Tags("Security"),
		),
	)

	return api
}
