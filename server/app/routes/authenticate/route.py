'''
Routes for /authenticate
'''
from typing import Callable
from flask import Response
from flongo_framework.api.routing import Route_Handler
from flongo_framework.api.routing.utils import Authentication_Util
from flongo_framework.api.requests import App_Request
from flongo_framework.api.responses import API_JSON_Response, API_Message_Response
from flongo_framework.api.responses.errors import API_Error_Message

class AuthenticateRouteHandler(Route_Handler):

    def POST(self, request:App_Request):
        ''' Authenticates a user '''

        raw_pw = request.payload.pop("password")
        username = request.payload.get('username')
        if not (user := request.run_mongo_operation(op='find_one')):
            raise API_Error_Message(f"Username [{username}] not found!", status_code=404)
        
        if not (Authentication_Util.validate_password(raw_pw, user.get('password'))):
            raise API_Error_Message(f"Invalid password for [{username}]!", status_code=401)

        return Authentication_Util.set_identity_cookies(response=API_JSON_Response(user),
            _id=str(user.get("_id")),
            username=user.get("username"),
            email=user.get("email_address"),
            roles=user.get("roles", "user")
        )

    def DELETE(self, request:App_Request):
        ''' De-authenticates a user '''
        
        return Authentication_Util.unset_identity_cookies(
            response=API_Message_Response("Logged out!"),
        )
    
    # Holds a reference of all methods for this route
    def __init__(self, **methods:Callable[[App_Request], Response]):
        methods = {**{
            "POST": self.POST,
            "DELETE": self.DELETE
        }, **methods}

        super().__init__(**methods)
