from flongo_framework.api.routing import App_Routes, Route, Route_Handler, Default_Route_Handler

from flongo_framework.api.routing.route_permissions import Route_Permissions
from flongo_framework.api.responses import API_Message_Response
from flongo_framework.config.enums.logs.log_levels import LOG_LEVELS

# User Management
from .routes.user.route import UserRouteHandler
from .routes.user.schema import  USER_ROUTE_REQUEST_SCHEMA
from .routes.user.transformer import USER_ROUTE_REQUEST_TRANSFORMER, USER_ROUTE_RESPONSE_TRANSFORMER

# User Authentication
from .routes.authenticate.route import AuthenticateRouteHandler
from .routes.authenticate.schema import AUTHENTICATION_ROUTE_REQUEST_SCHEMA
from .routes.authenticate.transformer import AUTHENTICATION_ROUTE_RESPONSE_TRANSFORMER


# Application Endpoints/Routes
APP_ROUTES = App_Routes(
    # Ping
    Route(
        url='/ping',
        handler=Route_Handler(
            GET=lambda request: API_Message_Response("It's alive!")
        ),
        log_level=LOG_LEVELS.DEBUG
    ),

    # Authentication
    Route(
        url='/authenticate',
        handler=AuthenticateRouteHandler(),
        permissions=Route_Permissions(DELETE=['user', 'admin']),
        collection_name='users',
        request_schema=AUTHENTICATION_ROUTE_REQUEST_SCHEMA,
        response_transformer=AUTHENTICATION_ROUTE_RESPONSE_TRANSFORMER,
        log_level=LOG_LEVELS.DEBUG
    ),

    # API Accessible Config
    Route(
        url='/config',
        handler=Default_Route_Handler(),
        permissions=Route_Permissions(GET='admin', POST='admin', PUT='admin', PATCH='admin', DELETE='admin'),
        collection_name='config',
        log_level=LOG_LEVELS.DEBUG
    ),

    # User Management
    Route(
        url='/user',
        handler=UserRouteHandler(PUT=None),
        permissions=Route_Permissions(GET=['user', 'admin'], PATCH=['user', 'admin'], DELETE=['user', 'admin']),
        collection_name='users',
        request_schema=USER_ROUTE_REQUEST_SCHEMA,
        request_transformer=USER_ROUTE_REQUEST_TRANSFORMER,
        response_transformer=USER_ROUTE_RESPONSE_TRANSFORMER,
        log_level=LOG_LEVELS.DEBUG
    ),
)
