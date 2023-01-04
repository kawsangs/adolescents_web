# adolescents_web

The adolescents_web is a youth health web application and backend API for [adolescents_app](https://github.com/kawsangs/adolescents_app) Application.

## Development Setup
### System dependencies

Adolescents_web is a standard Rails application, and it also needs the following services to run:
- PostgreSQL: 14.4
- Docker
- Docker Compose

### Configuration
In ```app.env``` file: copy content in ```app.env.example``` to the file

1. To enable feature **Sign in with Google**:
The Client ID obtained from the [Google Console](https://developers.google.com/maps/documentation/maps-static/get-api-key). Replace with your own Client ID and Client Secret

```
GOOGLE_CLIENT_ID=client_id
GOOGLE_CLIENT_SECRET=client_secret
```
2. To enable feature **Sentry logger**:
Signup with sentry.io to get SENTRY_DSN and replace the URL
```
SENTRY_DSN=url
```

## Installation
- Install [Docker](https://docs.docker.com/get-docker/)
- install [Docker Compose](https://docs.docker.com/compose/install/)

## Docker development
```docker-compose.yml``` file builds a development environment mounting the current folder and running rails in a development environment.

Run the following commands to have a stable development environment.
```
$ docker-compose run --rm web bundle install
$ docker-compose run --rm web bundle exec rake db:dev
$ docker-compose up
```
And visit [localhost:3000](localhost:3000)

To set up and run the test, run
```
$ docker-compose run --rm web bundle exec rspec spec
```

To run lint
```
$ docker-compose run --rm web bundle exec rubocop .
```
