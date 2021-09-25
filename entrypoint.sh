#! /bin/bash

# Global variables

SERVER_CONFIG_DIR="/home/web/server"

# Path definitions

NGINX_CONFIG_DIR="${SERVER_CONFIG_DIR}/nginx"
NGINX_CONFIG_FILE="${NGINX_CONFIG_DIR}/nginx.conf"

# Bin definitions

## Nginx ##
NGINX_BIN="/etc/init.d/nginx"
NGINX_FLAGS="start"

echo "$(date) - Starting containers..."

echo "$(date) - Checking database server..."

while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - Waiting for database to start..."
  sleep 2
done

echo "$(date) - Database server is up!"
echo "$(date) - Checking if $PGDATABASE exists..."

if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  createdb -E UTF8 $PGDATABASE -l en_US.UTF-8 -T template0

  ## Database migration goes here!!!###


  echo "Database $PGDATABASE created!"
fi

echo "$(date) - Starting web server..."

$NGINX_BIN $NGINX_FLAGS
