# ---- Build Arguments for Base Image ----
ARG BASE_IMAGE=ghcr.io/cloudnative-pg/postgresql
ARG OS_TAG=bookworm
ARG PG_VERSION=15

FROM ${BASE_IMAGE}:${PG_VERSION}-${OS_TAG}

USER root

# DAS commit SHAs to pin
ARG DAS_C_VERSION=3ef25cdeda1a26374a5695ca31f392ec03a0f01a
ARG DAS_PY_VERSION=616e7d17ba33d14c7b82503d1fd7ee802bd1f715

ENV PGDATA=/data
ENV PATH="$PATH:/usr/local/go/bin"
ENV LANG=en_US.UTF-8

# Copy initialization SQL script
COPY init.sql /docker-entrypoint-initdb.d/

# Copy your custom DAS installer
COPY install_das.sh /install_das.sh

# Install required packages and run install_das
RUN set -eux \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        git \
        rsync \
        gettext \
        clang-15 \
        postgresql-server-dev-15 \
        alien \
        libaio1 \
    # ---- Install your DAS components ----
    && /install_das.sh "${DAS_C_VERSION}" "${DAS_PY_VERSION}" \
    # ---- Clean up apt cache ----
    && rm -rf /var/lib/apt/lists/*

# Copy our small script that does envsubst at container startup
COPY init-subs.sh /usr/local/bin/init-subs.sh
RUN chmod +x /usr/local/bin/init-subs.sh

# By default, the official Postgres container listens on port 5432
# We'll still EXPOSE it to be clear in metadata (not strictly required for Docker)
EXPOSE 5432

# We also "EXPOSE 50051" to indicate that this container (with DAS extension) might
# need access to a service on port 50051 — but the real key is using port mappings.
EXPOSE 50051

# Use our script as the entrypoint so it can substitute environment variables
ENTRYPOINT ["init-subs.sh"]

# The default command remains "postgres"
CMD ["postgres"]
