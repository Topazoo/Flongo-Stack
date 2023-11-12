'''
Routes for /email_confirmation
'''
from typing import Callable
from bson import ObjectId
from flask import Response
from datetime import datetime
from flongo_framework.api.routing import Route_Handler
from flongo_framework.api.requests import App_Request
from flongo_framework.api.responses import API_Message_Response
from flongo_framework.utils.logging.loggers import RoutingLogger
from flongo_framework.utils.email import Gmail_Client
from flongo_framework.config.settings import App_Settings
from flongo_framework.database import MongoDB_Database
from flongo_framework.database import MongoDB_Database

class Email_Confirmation_Route_Handler(Route_Handler):

    @classmethod
    def send_confirmation_email(cls, request:App_Request, user_id:str) -> bool:
        ''' Sends a confirmation email to a user email address '''

        email = request.payload['email_address']
        try:
            with MongoDB_Database('email_confirmations') as confirmation_db:
                token = str(confirmation_db.insert_one(
                    {'createdOn': datetime.now(), 'user_id': ObjectId(user_id)}
                ).inserted_id)

            Gmail_Client().send_email(
                email, 
                "Please Confirm Your Email Address", 
                f"Please use the following link to confirm your email: {App_Settings().flask.domain}/email_confirmation?token={token}"
            )

            return True
        
        except Exception as e:
            # TODO - Sentry log
            RoutingLogger(request.raw_request.base_url).error(
                f"Failed to send confirmation email to [{email}]! {e}",
            )

        return False


    def GET(self, request:App_Request) -> Response:
        ''' Checks to see if an email confirmation is valid '''

        if request.collection != None:
            if confirmation:= request.collection.find_one({"_id": ObjectId(request.payload["token"])}):
                with MongoDB_Database('users') as users:
                    if users.update_one({"_id": confirmation["user_id"]}, {"$set": {"is_email_validated": True}}).modified_count:
                        return API_Message_Response('Email validated successfully!')
                    
                    return API_Message_Response('Email is already validated!')
            
        return API_Message_Response('The confirmation token is invalid or expired', 404)
    

    def POST(self, request:App_Request) -> Response:
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
        

    def PUT(self, request:App_Request) -> Response:
        ''' Resends a confirmation email '''

        with MongoDB_Database('users') as users:
            if not (user := users.find_one(
                {"username": request.payload.get("username"), "email_address": request.payload.get("email_address")},
                {"_id": 1}
            )):
                return API_Message_Response(f'Email address [{request.payload.get("email_address")}] not found!',  404)

        if self.send_confirmation_email(request, str(user.get('_id'))):
            return API_Message_Response(f"Re-sent confirmation email to [{request.payload.get('email_address')}]")

        return API_Message_Response(f"Failed to re-send confirmation email to [{request.payload.get('email_address')}]", 500)

    
    # Holds a reference of all methods for this route
    def __init__(self, **methods:Callable[[App_Request], Response]):
        methods = {**{"GET": self.GET, "POST": self.POST, "PUT": self.PUT}, **methods}
        super().__init__(**methods)
