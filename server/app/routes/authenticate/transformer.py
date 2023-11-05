'''
Transformer for /authenticate
'''
from flongo_framework.api.routing import Route_Transformer, Field_Transformer
from flongo_framework.api.routing.utils import Authentication_Util

# Hash the password in POST requests
AUTHENTICATION_ROUTE_REQUEST_TRANSFORMER = Route_Transformer(
    POST = [Field_Transformer("password", Authentication_Util.hash_password)]
)

# Filter out ID and password from successful login
AUTHENTICATION_ROUTE_RESPONSE_TRANSFORMER = Route_Transformer(
    POST = [Field_Transformer("password", lambda _: None), Field_Transformer("_id", lambda _: None)]
)