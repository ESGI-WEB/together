package swagger

import (
	"github.com/labstack/echo/v4"
)

func SetupSwaggerRoutes(e *echo.Echo) {
	securitySwagger := SetupSecuritySwagger()
	addressSwagger := SetupAddressSwagger()
	eventSwagger := SetupEventSwagger()
	eventTypeSwagger := SetupEventTypeSwagger()
	featureSwagger := SetupFeatureSwagger()
	groupSwagger := SetupGroupSwagger()
	userSwagger := SetupUserSwagger()

	RegisterSwaggerRoutes(e, securitySwagger, addressSwagger, eventSwagger, eventTypeSwagger, featureSwagger, groupSwagger, userSwagger)
}
