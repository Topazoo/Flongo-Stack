'''
Transformer for /user
'''
from flongo_framework.api.routing import Route_Transformer, Field_Transformer
from flongo_framework.api.routing.utils import Authentication_Util
from datetime import datetime

# Hash the password in POST requests and set the created time, set the roles to user
# Hash the password in PATCH requests and set the modified time
USER_ROUTE_REQUEST_TRANSFORMER = Route_Transformer(
    POST = [
        Field_Transformer("createdOn", datetime.utcnow, is_default=True),
        Field_Transformer("roles", lambda: ["user"], is_default=True),
        Field_Transformer("is_email_validated", lambda: False, is_default=True),
        Field_Transformer("password", Authentication_Util.hash_password),
    ],
    PATCH = [
        Field_Transformer("modifiedOn", datetime.utcnow, is_default=True),
        Field_Transformer("password", Authentication_Util.hash_password),        
    ]
)

# Filter out password
USER_ROUTE_RESPONSE_TRANSFORMER = Route_Transformer(
    GET = [Field_Transformer("password", lambda _: '')]
)
