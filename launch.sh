#!/bin/bash

set -e

echo "Waiting for Postgres..."
/wait-for-it.sh db:5432 --timeout=60 --strict -- echo "Postgres is up."
sleep 10  # Add this

echo "Waiting for LiteLLM..."
/wait-for-it.sh litellm:4000 --timeout=60 --strict -- echo "LiteLLM is up."

# Optional: Check actual HTTP readiness (replace with real endpoint if needed)
until curl -sf http://litellm:4000/health || curl -sf http://litellm:4000/; do
  echo "Waiting for LiteLLM HTTP service to respond..."
  sleep 2
done

echo "All dependencies are ready. Launching Open WebUI..."
exec bash start.sh
