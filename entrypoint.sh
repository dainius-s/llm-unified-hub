#!/bin/bash

echo "[Entrypoint] Waiting for db:5432"
/wait-for-it.sh db:5432 --timeout=60 --strict -- echo " DB is up"

echo "[Entrypoint] Sleeping for 20 seconds..."
sleep 20

echo "[Entrypoint] Launching WebUI"
exec bash start.sh
