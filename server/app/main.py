# App Driver
from flongo_framework.application import Application

# Configured App Routes / Endpoints
from .routing import APP_ROUTES

# Configured App Settings
from .settings import SETTINGS

# Configured App Database Indices
from .database.indices import INDICES

# Configured App Database Fixtures
from .database.fixtures import FIXTURES


# Create application
app = Application(
    routes=APP_ROUTES, 
    settings=SETTINGS, 
    indices=INDICES,
    fixtures=FIXTURES
)

# Binding directly to Flask for Gunicorn or VSCode
def get_app():
    return app.app

if __name__ == '__main__':
    # Run application
    app.run()
