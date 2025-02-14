# Custom PostgreSQL Docker Image with DAS Extension

This repository contains a Docker image based on 
[CloudNative PG](https://github.com/cloudnative-pg/postgresql) **PostgreSQL 15** 
with the DAS extension installed. 

---

## Table of Contents

1. [Features](#features)
2. [Build the Image](#build-the-image)
3. [Run the Container](#run-the-container)
4. [Connect to PostgreSQL](#connect-to-postgresql)
5. [Using the DAS Extension](#using-the-das-extension)
6. [Contributing](#contributing)

---

## Features

- **PostgreSQL 15** with [DAS extension](https://some-das-link.example) installed.
- Passwords handled via environment variables at runtime (no credentials in build layers).

---

## Build the Image

Clone this repository and from the project root run:

```bash
docker build -t my-postgres-das:latest .
```

This command:
1. Pulls the base Postgres image (ghcr.io/cloudnative-pg/postgresql:15-bookworm).
2. Installs required dependencies and compiles the DAS extension.

## Run the Container

__Important__: By default, PostgreSQL listens on port 5432. You may already have a local Postgres running on 5432. To avoid conflicts, you can map a different port on your host machine to the container’s 5432 port—e.g., 65432.

Here’s an example run command:

```bash
docker run -it --rm \
  -e POSTGRES_PASSWORD="mysecret" \
  -e ADMIN_PASSWORD="anothersecret" \
  -e READONLY_PASSWORD="readonlysecret" \
  -p 65432:5432 \                                   # Host port 65432 -> Container port 5432
  --add-host=host.docker.internal:host-gateway \    # Allows services within Docker to reach external services
  --name my-postgres-das \
  my-postgres-das:latest
```

Explanation:
* -e POSTGRES_PASSWORD: sets the Postgres superuser password at runtime.
* -e ADMIN_PASSWORD: sets the password for a newly-created Postgres admin role
* -e READONLY_PASSWORD: sets the password for a newly-created Postgres read-only role
* -p 65432:5432: container’s port 5432 is exposed on your host at port 65432 so you can safely connect without conflicting with any local Postgres server running on 5432.

## Connect to PostgreSQL

Once the container is running, you can connect to it with any PostgreSQL client (e.g., psql). If you don’t have psql installed locally:
* macOS: brew install postgresql
* Debian/Ubuntu: sudo apt-get install postgresql-client*
* Windows: Install from the official PostgreSQL downloads.

Then connect:

```bash
psql -h 127.0.0.1 -p 65432 -U postgres
```

* -h 127.0.0.1: connect to localhost on your machine.
* -p 65432: use the mapped port (instead of the default 5432).
* -U postgres: use the postgres superuser (or whatever user you set).

You will be prompted for the password (in this example, `mysecret`).

## Using the DAS Extension

Please refer to [https://github.com/raw-labs/das-server-python-mock](https://github.com/raw-labs/das-server-python-mock) for an example on how to run a DAS server and connect it to this PostgreSQL instance.
