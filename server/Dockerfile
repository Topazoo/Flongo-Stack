# Server Build
FROM python:3.9-slim-buster as build

LABEL maintainer="Peter Swanson | pswanson@ucdavis.edu"

WORKDIR /app
COPY app/ /app/app
COPY setup/requirements.txt /app/setup/requirements.txt

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc libffi-dev libssl-dev python3-dev && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r /app/setup/requirements.txt && \
    apt-get remove -y gcc libffi-dev libssl-dev python3-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Final image
FROM python:3.9-slim-buster

# Copy required files from build stage
COPY --from=build /usr/local /usr/local
COPY --from=build /app /app
COPY entrypoint.sh /entrypoint.sh

WORKDIR /app

# Set environment variables with default values
ENV FLASK_APP=app/main.py
ENV APP_HOST=0.0.0.0
ENV APP_PORT=8080

ENV APP_LOG_LEVEL=debug
ENV APP_CONFIG_LOG_LEVEL=debug
ENV MONGODB_LOG_LEVEL=debug

ENV GUNICORN_WORKERS=1
ENV GUNICORN_TIMEOUT=30

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Expose the port Flask will run on
EXPOSE ${APP_PORT}

ENTRYPOINT ["/entrypoint.sh"]
