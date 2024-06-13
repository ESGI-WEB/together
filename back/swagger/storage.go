package swagger

import (
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/endpoint"
	"github.com/zc2638/swag/option"
	"net/http"
	"together/controllers"
)

func SetupStorageSwagger() *swag.API {
	api := swag.New(
		option.Title("Storage API Doc"),
		option.Tag("Storage", "Endpoints related to retrieving image files from S3."),
	)

	storageController := controllers.NewStorageController()

	api.AddEndpoint(
		endpoint.New(
			http.MethodGet, "/storage/:path",
			endpoint.Handler(storageController.GetImage),
			endpoint.Summary("Get image"),
			endpoint.Description("Returns an image file."),
			endpoint.Response(http.StatusOK, "Successfully retrieved image file", endpoint.SchemaResponseOption("string")),
			endpoint.Response(http.StatusNotFound, "Image file not found"),
			endpoint.Response(http.StatusInternalServerError, "Internal server error"),
			endpoint.Tags("Storage"),
		),

	)

	return api
}
