#!/bin/bash
set -e

echo "=== Building local Docker images ==="

echo "[1/3] Building database image..."
docker build -t toy-bank-database:local ./database

echo "[2/3] Building API image..."
docker build -t toy-bank-api:local ./api

echo "[3/3] Building frontend image..."
docker build -t toy-bank-frontend:local \
  --build-arg BACKEND_API=http://localhost:32227 \
  ./frontend

echo "=== All images built successfully ==="
echo ""
echo "Now run:  kubectl create -f deployment/local/"
