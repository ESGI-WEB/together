package swagger

import (
	"github.com/labstack/echo/v4"
)

func SetupSwaggerRoutes(e *echo.Echo) {
	RegisterSwaggerRoutes(e,
		SetupSecuritySwagger(),
		SetupAddressSwagger(),
		SetupEventSwagger(),
		SetupEventTypeSwagger(),
		SetupFeatureSwagger(),
		SetupGroupSwagger(),
		SetupUserSwagger(),
		SetupHelloSwagger(),
		SetupStorageSwagger(),
		SetupAdminSwagger(),
		SetupMessageSwagger(),
	)
}
