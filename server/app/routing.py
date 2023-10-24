from flongo_framework.api.routing import App_Routes, Route, Route_Handler, Default_Route_Handler
from flongo_framework.api.routing.utils import Authentication_Util
from flongo_framework.api.routing.route_permissions import Route_Permissions

from flongo_framework.api.responses import API_Message_Response

from flongo_framework.config.enums.logs.log_levels import LOG_LEVELS

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
        handler=Route_Handler(
            POST=lambda request: Authentication_Util.set_identity_cookies(
                response=API_Message_Response("Logged in!"),
                _id=request.payload.get("username", "Test Username"),
                roles="admin"
            ),
            DELETE=lambda request: Authentication_Util.unset_identity_cookies(
                response=API_Message_Response("Logged out!"),
            )
        ),
        permissions=Route_Permissions(DELETE=['user', 'admin']),
        log_level=LOG_LEVELS.DEBUG
    ),

    # API Accessible Config
    Route(
        url='/config',
        handler=Default_Route_Handler(),
        permissions=Route_Permissions(
            GET='admin',
            POST='admin',
            PUT='admin',
            PATCH='admin',
            DELETE='admin'
        ),
        collection_name='config',
        log_level=LOG_LEVELS.DEBUG
    ),
)
