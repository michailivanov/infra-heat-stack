#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    \c currency_converter;
    \i /docker-entrypoint-initdb.d/create.sql;
EOSQL
