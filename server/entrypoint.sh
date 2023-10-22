#!/bin/sh

# Entrypoint for Dockerfile

export PYTHONPATH=$PYTHONPATH:/app

# Check the current environment. Sandbox or higher uses gunicorn
if [ "$APP_ENV" = "sandbox" ] || [ "$APP_ENV" = "prod" ] || [ "$APP_ENV" = "production" ]; then
    # Use Gunicorn for the listed environments
    # Demo can be interchanged with any Python file name with a get_app() binding defined
    exec gunicorn "${FLASK_APP}()" -w ${GUNICORN_WORKERS} -b ${APP_HOST}:${APP_PORT} -t ${GUNICORN_TIMEOUT}
else
    # Use Flask's development server
    exec flask run --host=${APP_HOST} --port=${APP_PORT} --reload
fi