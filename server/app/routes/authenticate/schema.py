'''
Schema for /authenticate
'''
from flongo_framework.api.routing import Route_Schema

AUTHENTICATION_ROUTE_REQUEST_SCHEMA = Route_Schema(
    # Authenticate a user
    POST = {
        'type': 'object',
        'additionalProperties': False,
        'properties': {
            'username': {'type': 'string', "minLength": 4},
            'password': {'type': 'string', "minLength": 5},
        },
        'required': ['username', 'password']
    },

    # De-Authenticate a user
    DELETE = {
        'type': 'object',
        'additionalProperties': False,
        'properties': {},
        'required': []
    }
)