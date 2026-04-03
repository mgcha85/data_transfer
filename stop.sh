#!/bin/bash

# Stop the MinerU server
if [ -f .server.pid ]; then
    PID=$(cat .server.pid)
    echo "Stopping MinerU (PID $PID)..."
    kill $PID
    rm .server.pid
    echo "MinerU stopped."
else
    # Fallback to pkill if PID file is missing
    echo "PID file .server.pid not found. Trying to kill by process name..."
    pkill -f "uvicorn.*mineru"
    echo "Attempted pkill. Done."
fi
