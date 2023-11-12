'''
Routes for /email_confirmation
'''
from typing import Callable
from bson import ObjectId
from flask import Response
from flongo_framework.api.routing import Route_Handler
from flongo_framework.api.requests import App_Request
from flongo_framework.api.responses import API_Message_Response

from flongo_framework.database import MongoDB_Database

class Email_Confirmation_Route_Handler(Route_Handler):

    def GET(self, request:App_Request):
        ''' Checks to see if an email confirmation is valid '''

        if request.collection != None:
            if confirmation:= request.collection.find_one({"_id": ObjectId(request.payload["token"])}):
                with MongoDB_Database('users') as users:
                    if users.update_one({"_id": confirmation["_id"]}, {"$set": {"is_email_validated": True}}).modified_count:
                        return API_Message_Response('Email validated successfully!')
                    
                    return API_Message_Response('Email is already validated!')
            
        return API_Message_Response('The confirmation token is invalid or expired', 404)

    
    # Holds a reference of all methods for this route
    def __init__(self, **methods:Callable[[App_Request], Response]):
        methods = {**{"GET": self.GET}, **methods}
        super().__init__(**methods)
