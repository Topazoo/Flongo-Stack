'''
Schema for /email_confirmation
'''
from flongo_framework.api.routing import Route_Schema

EMAIL_CONFIRMATION_ROUTE_REQUEST_SCHEMA = Route_Schema(
    # Confirm an email
    GET = {
        'type': 'object',
        'additionalProperties': False,
        'properties': {
            'token': {'type': 'string', "minLength": 24, "maxLength": 24},
        },
        'required': ['token']
    },

    # Check if an email is confirmed
    POST = {
        'type': 'object',
        'additionalProperties': False,
        'properties': {
            'username': {'type': 'string', "minLength": 4},
            'email_address': {
                'type': 'string',
                'pattern': r'^([a-zA-Z0-9_\-\.\+]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$'
            }
        },
        'required': ['username', 'email_address']
    }
)