package swagger

import (
	"github.com/labstack/echo/v4"
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/option"
	"net/http"
)

func RegisterSwaggerRoutes(e *echo.Echo, apis ...*swag.API) {
	combinedAPI := swag.New(
		option.Title("Together API Doc"),
		option.SecurityScheme("bearer_auth",
			option.OAuth2Security("bearer", "", "http://example.com/oauth/token"),
		),
	)

	for _, api := range apis {
		api.Walk(func(path string, ep *swag.Endpoint) {
			combinedAPI.AddEndpoint(ep)
			h, ok := ep.Handler.(func(echo.Context) error)
			if !ok {
				e.Logger.Fatalf("Handler invalide pour le chemin %s", path)
				return
			}
			path = swag.ColonPath(path)
			switch ep.Method {
			case http.MethodGet:
				e.GET(path, h)
			case http.MethodPost:
				e.POST(path, h)
			case http.MethodPut:
				e.PUT(path, h)
			case http.MethodDelete:
				e.DELETE(path, h)
			default:
				e.Logger.Infof("Méthode HTTP %s non gérée pour le chemin %s", ep.Method, path)
			}
			e.Logger.Infof("Route enregistrée: %s %s", ep.Method, path)
		})
	}

	e.GET("/swagger/json", echo.WrapHandler(combinedAPI.Handler()))
	e.GET("/swagger/ui/*", echo.WrapHandler(swag.UIHandler("/swagger/ui", "/swagger/json", true)))
}
