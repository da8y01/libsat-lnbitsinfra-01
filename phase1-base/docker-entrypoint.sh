#!/bin/bash
set -e

# Templar torrc con la variable de entorno TOR_HASHED_CONTROL_PASSWORD
if [ -f /etc/tor/torrc.template ]; then
    envsubst '${TOR_HASHED_CONTROL_PASSWORD}' < /etc/tor/torrc.template > /etc/tor/torrc
fi

# Ejecutar el comando principal (supervisord)
exec "$@"
