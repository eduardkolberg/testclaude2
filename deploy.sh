#!/bin/bash
set -e

echo "Starting deployment..."

# Stop and remove existing container
docker stop hello-world-app || true
docker rm hello-world-app || true

# Remove old image
docker rmi hello-world-app:latest || true

# Build new image
docker build -t hello-world-app:latest .

# Run new container
docker run -d \
  --name hello-world-app \
  --restart unless-stopped \
  -p 80:3000 \
  hello-world-app:latest

echo "Deployment completed successfully!"
docker ps | grep hello-world-app
