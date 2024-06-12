package swagger

import (
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/endpoint"
	"github.com/zc2638/swag/option"
	"net/http"
	"together/controllers"
	"together/models"
)

func SetupFeatureSwagger() *swag.API {
	api := swag.New(
		option.Title("Feature API Doc"),
		option.SecurityScheme("bearer_auth",
			option.APIKeySecurity("Authorization", "header"),
		),
		option.Tag("Feature", "Endpoints related to feature flipping operations"),
	)

	featureController := controllers.NewFeatureController()

	api.AddEndpoint(
		endpoint.New(
			http.MethodGet, "/features",
			endpoint.Handler(featureController.List),
			endpoint.Summary("List all features"),
			endpoint.Description("Returns a list of all feature flipping configurations."),
			endpoint.Response(http.StatusOK, "Successfully retrieved list of features", endpoint.SchemaResponseOption([]models.FeatureFlipping{})),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Feature"),
		),
		endpoint.New(
			http.MethodGet, "/features/{slug}",
			endpoint.Handler(featureController.View),
			endpoint.Summary("Get feature by slug"),
			endpoint.Description("Returns the feature flipping configuration identified by the provided slug."),
			endpoint.Path("slug", "string", "Slug of the feature to return", true),
			endpoint.Response(http.StatusOK, "Successfully retrieved feature", endpoint.SchemaResponseOption(models.FeatureFlipping{})),
			endpoint.Response(http.StatusNotFound, "Feature not found"),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Feature"),
		),
		endpoint.New(
			http.MethodPatch, "/features/{slug}",
			endpoint.Handler(featureController.Edit),
			endpoint.Summary("Edit feature by slug"),
			endpoint.Description("Edits the feature flipping configuration identified by the provided slug."),
			endpoint.Path("slug", "string", "Slug of the feature to edit", true),
			endpoint.Body(models.EditFeatureFlipping{}, "Feature object that needs to be edited", true),
			endpoint.Response(http.StatusOK, "Successfully edited feature", endpoint.SchemaResponseOption(models.FeatureFlipping{})),
			endpoint.Response(http.StatusBadRequest, "Invalid input"),
			endpoint.Response(http.StatusUnprocessableEntity, "Validation error"),
			endpoint.Response(http.StatusUnauthorized, "User not authenticated"),
			endpoint.Response(http.StatusNotFound, "Feature not found"),
			endpoint.Security("bearer_auth"),
			endpoint.Tags("Feature"),
		),
	)

	return api
}
