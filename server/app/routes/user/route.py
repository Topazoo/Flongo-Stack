'''
Routes for /user
'''
from flongo_framework.api.routing import Default_Route_Handler
from flongo_framework.api.requests import App_Request
from ..email_confirmation.route import Email_Confirmation_Route_Handler

class UserRouteHandler(Default_Route_Handler):
    def _check_identity(self, request:App_Request):
        ''' Ensures the _id passed in the payload matches the passed identity or is an admin '''

        if not request.is_admin_identity() or "_id" not in request.payload:
            request.ensure_payload_has_valid_identity()


    def POST(self, request:App_Request):
        ''' Gets a user '''
        
        response = super().POST(request)
        Email_Confirmation_Route_Handler.send_confirmation_email(request, (response.json or {}).get('_id', ''))
        
        return response


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
