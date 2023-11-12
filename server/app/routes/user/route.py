'''
Routes for /user
'''
from bson import ObjectId
from flask import Response
from flongo_framework.api.routing import Default_Route_Handler
from flongo_framework.api.requests import App_Request
from flongo_framework.utils.logging.loggers import RoutingLogger
from flongo_framework.utils.email import Gmail_Client
from flongo_framework.config.settings import App_Settings
from flongo_framework.database import MongoDB_Database
from datetime import datetime

class UserRouteHandler(Default_Route_Handler):
    def _check_identity(self, request:App_Request):
        ''' Ensures the _id passed in the payload matches the passed identity or is an admin '''

        if not request.is_admin_identity() or "_id" not in request.payload:
            request.ensure_payload_has_valid_identity()


    def _send_confirmation_email(self, request:App_Request, response:Response) -> Response:
        ''' Sends a confirmation email to a user email address '''

        email = request.payload['email_address']
        try:
            with MongoDB_Database('email_confirmations') as confirmation_db:
                token = str(confirmation_db.insert_one(
                    {'createdOn': datetime.now(), '_id': ObjectId((response.json or {}).get('_id', ''))}
                ).inserted_id)

            Gmail_Client().send_email(
                email, 
                "Please Confirm Your Email Address", 
                f"Please use the following link to confirm your email: {App_Settings().flask.domain}/email_confirmation?token={token}"
            )
        except Exception as e:
            # TODO - Sentry log
            RoutingLogger(request.raw_request.base_url).error(
                f"Failed to send confirmation email to [{email}]! {e}",
            )
        finally:
            return response


    def POST(self, request:App_Request):
        ''' Gets a user '''
        
        response = super().POST(request)
        return self._send_confirmation_email(request, response)


    def GET(self, request:App_Request):
        ''' Gets a user '''
        
        self._check_identity(request)
        return super().GET(request)
        
        
    def PATCH(self, request:App_Request):
        ''' Updates a user '''
        
        self._check_identity(request)
        return super().PATCH(request)


    def DELETE(self, request:App_Request):
        ''' Deletes a user '''
        
        self._check_identity(request)
        return super().DELETE(request)
