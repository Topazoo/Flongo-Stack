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
