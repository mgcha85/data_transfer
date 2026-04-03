#!/bin/bash

# Default environment to dev if not specified
ENV=${1:-dev}
ENV_FILE=".env.$ENV"

if [ ! -f "$ENV_FILE" ]; then
    echo "Environment file $ENV_FILE not found!"
    exit 1
fi

echo "Starting MinerU in $ENV mode using $ENV_FILE..."

# Export variables from .env file
export $(grep -v '^#' $ENV_FILE | xargs)

# Ensure models directory exists
mkdir -p ./models

# Run the API server
# Using uv to run if available, otherwise fallback to python
if command -v uv > /dev/null; then
    uv run uvicorn mineru.cli.fast_api:app --host ${MINERU_API_HOST:-0.0.0.0} --port ${MINERU_API_PORT:-8000} --workers ${MINERU_API_WORKERS:-1} > server.log 2>&1 &
else
    python3 -m uvicorn mineru.cli.fast_api:app --host ${MINERU_API_HOST:-0.0.0.0} --port ${MINERU_API_PORT:-8000} --workers ${MINERU_API_WORKERS:-1} > server.log 2>&1 &
fi

echo $! > .server.pid
echo "MinerU started with PID $(cat .server.pid). Logs are in server.log"
