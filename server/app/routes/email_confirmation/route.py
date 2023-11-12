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
    

    def POST(self, request:App_Request):
        ''' Checks to see if an email is confirmed '''

        with MongoDB_Database('users') as users:
            if not (user := users.find_one(
                {"username": request.payload.get("username"), "email_address": request.payload.get("email_address")},
                {"is_email_validated": 1}
            )):
                return API_Message_Response(f'Email address [{request.payload.get("email_address")}] not found!',  404)

            if user.get('is_email_validated'):
                return API_Message_Response("Email validated!")
            
            return API_Message_Response("Email not validated!",  205)

    
    # Holds a reference of all methods for this route
    def __init__(self, **methods:Callable[[App_Request], Response]):
        methods = {**{"GET": self.GET, "POST": self.POST}, **methods}
        super().__init__(**methods)
