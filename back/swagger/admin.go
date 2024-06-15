package swagger

import (
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/endpoint"
	"github.com/zc2638/swag/option"
	"net/http"
	"together/controllers"
	"together/services"
)

func SetupAdminSwagger() *swag.API {
	api := swag.New(
		option.Title("Admin API Doc"),
		option.SecurityScheme("bearer_auth",
			option.APIKeySecurity("Authorization", "header"),
		),
		option.Tag("Admin", "Endpoints related to admin operations"),
	)

	adminController := controllers.NewAdminController()

	api.AddEndpoint(
		endpoint.New(
			http.MethodGet, "/admin/stats/monthly-last-year-registration-count",
			endpoint.Handler(adminController.GetMonthlyLastYearRegistrationsCount),
			endpoint.Summary("Get monthly last year registrations count"),
			endpoint.Description("Returns the count of registrations for each month of the last year."),
			endpoint.Response(http.StatusOK, "Successfully retrieved stats", endpoint.SchemaResponseOption([]services.MonthlyChartData{})),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Admin"),
		),
		endpoint.New(
			http.MethodGet, "/admin/stats/monthly-messages-count",
			endpoint.Handler(adminController.GetMonthlyMessagesCount),
			endpoint.Summary("Get monthly messages count"),
			endpoint.Description("Returns the count of messages for each month."),
			endpoint.Response(http.StatusOK, "Successfully retrieved stats", endpoint.SchemaResponseOption([]services.MonthlyChartData{})),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Admin"),
		),
		endpoint.New(
			http.MethodGet, "/admin/stats/event-types-count",
			endpoint.Handler(adminController.GetEventTypesCount),
			endpoint.Summary("Get event types count"),
			endpoint.Description("Returns the count of events for each type."),
			endpoint.Response(http.StatusOK, "Successfully retrieved stats", endpoint.SchemaResponseOption([]services.MonthlyChartData{})),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Admin"),
		),
	)

	return api
}
