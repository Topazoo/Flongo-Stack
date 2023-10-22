# client/Dockerfile

# Set a common work directory
ARG WORKDIR=/app

# Build the Flutter web app from an Ubuntu base
FROM ubuntu:latest AS FLUTTER_BUILDER

ARG WORKDIR
ARG FLUTTER_VERSION=3.13.8

# Install the required dependencies
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    file \
    git \
    unzip \
    zip \
    xz-utils \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Clone a specific version of Flutter SDK
RUN git clone --depth 1 -b $FLUTTER_VERSION https://github.com/flutter/flutter.git

ENV PATH="$PATH:/flutter/bin"
RUN flutter doctor

WORKDIR ${WORKDIR}

# Copy and build the Flutter app
COPY app ./
RUN flutter pub get
RUN flutter clean && flutter build web

# Serve the Flutter web app using nginx
FROM nginx:alpine

ARG WORKDIR=/app

# Copy the built Flutter app from the builder stage to nginx
COPY --from=FLUTTER_BUILDER ${WORKDIR}/build/web /usr/share/nginx/html

# Expose the default nginx port
EXPOSE 80

### THANK YOU: @Hard_Veur: https://stackoverflow.com/questions/75661539/building-a-docker-container-for-flutter-build-environment-fails-with-connectivit
