# Threeal Bot Workspace

[Docker](docker.com) container deployment workspace for [Threeal bot](https://github.com/threeal/threeal-bot).

## Prerequisites

- Follow [this guide](https://docs.docker.com/engine/install/) to install [Docker Engine](https://docs.docker.com/engine/).
  > As an alternative, you may deploy this project on the cloud using [Heroku](https://www.heroku.com/home) with the configurations that have been provided.

## Usage

- Build a Docker image using Docker Engine.
  ```bash
  $ docker build -t threeal-bot:latest .
  ```
  > As an alternative, you may change the `threeal-bot:latest` argument with any Docker image name that you desire.
- Create a `.env` file that contains the following environment variables configuration:
  - **(required)** `BOT_TOKEN`, fill it with the access token of your [Discord](https://discord.com/)'s bot (more info [here](https://github.com/threeal/threeal-bot#bot-setup)).
  - **(required)** `DB_URI`, fill it with the URI of your [MongoDB](https://www.mongodb.com/)'s server (more info [here](https://github.com/threeal/threeal-bot#database-setup)).
  - **(required)** `PORT`, fill it with the port of the HTTP server.
  - `NLU_URL`, fill it with the URL of your [NLU API server](https://github.com/threeal/threeal-bot-nlu). If not provided, the NLU API server will be run locally in this container.
  - `BOT_REPO`, fill it with the repo's URL of the custom bot module. If provided, the container will rebuild the bot module project using the contents of that repo.
  - `BOT_REPO_BRANCH`, an additional option for `BOT_REPO` that provides the name of the branch that will be used.
  - `NLU_REPO`, fill it with the repo's URL of the custom NLU module. If provided, the container will rebuild the NLU module project using the contents of that repo.
  - `NLU_REPO_BRANCH`, an additional option for `NLU_REPO` that provides the name of the branch that will be used.
- Run a container using the Docker image that has been build.
  ```bash
  $ docker run --rm --env-file .env --expose "$PORT" threeal-bot:latest
  ```
  > Replace `"$PORT"` with the same value as the `$PORT` environment variable in the `.env` file.
