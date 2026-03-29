#!/bin/bash
set -e

echo "=== Building Docker images ==="

echo "[1/3] Building database image..."
docker build -t toy-bank-database:local ./database

echo "[2/3] Building API image..."
docker build -t toy-bank-api:local ./api

echo "[3/3] Building frontend image..."
docker build -t toy-bank-frontend:local \
  --build-arg BACKEND_API=http://localhost:32227 \
  ./frontend

echo ""
echo "=== Loading images into Kubernetes (containerd k8s.io namespace) ==="

for IMAGE in toy-bank-database:local toy-bank-api:local toy-bank-frontend:local; do
  echo "Loading $IMAGE ..."
  docker save "$IMAGE" | docker run -i --rm --privileged --pid=host alpine \
    nsenter -t 1 -m -u -n -i ctr -n k8s.io images import -
done

echo ""
echo "=== Done! ==="
echo ""
echo "Now run:  kubectl create -f deployment/local/"
