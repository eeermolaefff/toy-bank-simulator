#!/bin/bash
set -e

REGISTRY="localhost:5050"

echo "=== Starting local Docker registry ==="
if ! docker ps --format '{{.Names}}' | grep -q '^local-registry$'; then
  docker rm -f local-registry 2>/dev/null || true
  docker run -d -p 5050:5000 --restart=always --name local-registry registry:2
  echo "Registry started at $REGISTRY"
else
  echo "Registry already running at $REGISTRY"
fi

echo ""
echo "=== Building and pushing Docker images ==="

echo "[1/3] Building database image..."
docker build -t $REGISTRY/toy-bank-database:local ./database
docker push $REGISTRY/toy-bank-database:local

echo "[2/3] Building API image..."
docker build -t $REGISTRY/toy-bank-api:local ./api
docker push $REGISTRY/toy-bank-api:local

echo "[3/3] Building frontend image..."
docker build -t $REGISTRY/toy-bank-frontend:local \
  --build-arg BACKEND_API=http://localhost:32227 \
  ./frontend
docker push $REGISTRY/toy-bank-frontend:local

echo ""
echo "=== All images built and pushed to $REGISTRY ==="
echo ""
echo "Now run:  kubectl create -f deployment/local/"
