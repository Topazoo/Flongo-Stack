# Flongo-Stack

Template Repo with a Flongo-Framework backend and Flutter frontend

## Server

### Building w/ Docker

From the `server` directory run:

```sh
docker build -t <your_image_name> .
```

### Running w/ Docker

Run the server image on port 8080 from the Docker GUI or with

```sh
docker run -p 8080:8080 <your_image_name>
```

Note: that MongoDB must be configured on the same Docker network as the app **(Use Docker Compose to do this automatically)**

### Building w/ Docker Compose

From the `server` directory containing `docker-compose.yml`, run:

```sh
docker-compose build
```

### Running the Server + MongoDB w/ Docker Compose

Since the server might depend on MongoDB, you can use Docker Compose to start the Dockerized application in conjuction with a Dockerized MongoDB instance.

Follow the `Building w/ Docker Compose` step then:

From the `server` directory containing `docker-compose.yml`, run the following to start the server on port 8080 and MongoDB on port 27017:

```sh
docker-compose up --force-recreate
```

If you are running the application with the environment configured to `sandbox` or higher, the application will run using gunicorn. If you are running with it configured in a lower environment, the application will run via Flask directly and will allow hot-reloads when code is changed

### Building the Client + Server + MongoDB w/ Docker Compose

Since the client depends on the server (which depends on MongoDB), you can use Docker Compose to start the Dockerized client application in conjuction with Dockerized Server and MongoDB instances

From the `compose` directory containing `docker-compose.yml`, run:

```sh
docker-compose build
```

You can build each component individually as well:

```sh
docker-compose build server
docker-compose build client
```

### Running the Client + Server + MongoDB w/ Docker Compose

From the `compose` directory containing `docker-compose.yml`, run the following to start the client on port 80, the server on port 8080 and MongoDB on port 27017:

```sh
docker-compose up --force-recreate
```
