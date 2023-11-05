'''
Routes for /user
'''
from flongo_framework.api.routing import Default_Route_Handler
from flongo_framework.api.requests import App_Request

class UserRouteHandler(Default_Route_Handler):
    def _check_identity(self, request:App_Request):
        ''' Ensures the _id passed in the payload matches the passed identity or is an admin '''

        if request.is_admin_identity():
            request.ensure_field("_id")
        else:
            request.ensure_payload_has_valid_identity()


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
