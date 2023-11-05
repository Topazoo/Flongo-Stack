'''
Schema for /user
'''
from flongo_framework.api.routing import Route_Schema

USER_ROUTE_REQUEST_SCHEMA = Route_Schema(
    # Get user details
    GET = {
        'type': 'object',
        'additionalProperties': False,
        'properties': {
            # ID of the user to fetch
            '_id': {'type': 'string', "minLength": 24, "maxLength": 24},
        },
        'required': []
    },

    # Create user
    POST = {
        'type': 'object',
        'additionalProperties': False,
        'properties': {
            'username': {'type': 'string', "minLength": 4},
            'password': {'type': 'string', "minLength": 5},
            'first_name': {'type': 'string', "minLength": 1},
            'last_name': {'type': 'string', "minLength": 1},
            'email_address': {
                'type': 'string',
                'pattern': r'^([a-zA-Z0-9_\-\.\+]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$'
            }
        },
        'required': ['username', 'first_name', 'last_name', 'password', 'email_address']
    },

    # Update user
    PATCH = {
        'type': 'object',
        'additionalProperties': False,
        'properties': {
            '_id': {'type': 'string', "minLength": 24, "maxLength": 24},
            'password': {'type': 'string', "minLength": 5},
            'first_name': {'type': 'string', "minLength": 1},
            'last_name': {'type': 'string', "minLength": 1},
            'email_address': {
                'type': 'string',
                'pattern': r'^([a-zA-Z0-9_\-\.\+]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$'
            }
        },
    },

    # Delete user
    DELETE = {
        'type': 'object',
        'additionalProperties': False,
        'properties': {
            '_id': {'type': 'string', "minLength": 24, "maxLength": 24}
        },
        'required': ['_id']
    }
)