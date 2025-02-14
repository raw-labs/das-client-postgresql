#!/usr/bin/env bash
set -e

# If we need to substitute environment variables into init.sql:
if [ -f /docker-entrypoint-initdb.d/init.sql ]; then
  echo "Substituting environment variables into init.sql..."
  envsubst < /docker-entrypoint-initdb.d/init.sql > /tmp/init.sql
  mv /tmp/init.sql /docker-entrypoint-initdb.d/init.sql
fi

# Finally, exec the official Postgres entrypoint script, passing along all arguments
exec docker-entrypoint.sh "$@"