#!/bin/bash
set -e

# Direct deployment script - deploys application directly to server via SSH
# This script is an alternative to GitHub Actions deployment

echo "Starting direct deployment to server..."

SERVER_HOST="49.13.52.51"
SERVER_USER="root"
SERVER_PASS="hvccuefb3qC4CuUmaHpc"

# Create deployment package
echo "Creating deployment package..."
tar -czf /tmp/app-deploy.tar.gz \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='*.sh' \
    --exclude='.github' \
    .

# Copy files to server
echo "Copying files to server..."
sshpass -p "$SERVER_PASS" scp -o StrictHostKeyChecking=no \
    /tmp/app-deploy.tar.gz \
    "$SERVER_USER@$SERVER_HOST:/tmp/"

# Execute deployment on server
echo "Executing deployment on server..."
sshpass -p "$SERVER_PASS" ssh -o StrictHostKeyChecking=no \
    "$SERVER_USER@$SERVER_HOST" << 'ENDSSH'

set -e

echo "Installing dependencies..."

# Update package lists
apt-get update -qq

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sh /tmp/get-docker.sh
    rm /tmp/get-docker.sh
    systemctl enable docker
    systemctl start docker
fi

# Install git if not present
if ! command -v git &> /dev/null; then
    echo "Installing git..."
    apt-get install -y git
fi

# Create app directory and extract files
echo "Setting up application..."
mkdir -p /opt/hello-world-app
cd /opt/hello-world-app
tar -xzf /tmp/app-deploy.tar.gz
rm /tmp/app-deploy.tar.gz

# Stop and remove existing container
echo "Stopping existing container..."
docker stop hello-world-app 2>/dev/null || true
docker rm hello-world-app 2>/dev/null || true

# Build new image
echo "Building Docker image..."
docker build -t hello-world-app:latest .

# Run new container
echo "Starting application..."
docker run -d \
  --name hello-world-app \
  --restart unless-stopped \
  -p 80:3000 \
  hello-world-app:latest

# Verify deployment
echo "Verifying deployment..."
sleep 3
if docker ps | grep -q hello-world-app; then
    echo "✓ Deployment successful!"
    docker ps | grep hello-world-app
else
    echo "✗ Deployment failed!"
    docker logs hello-world-app 2>/dev/null || true
    exit 1
fi

ENDSSH

# Cleanup
rm -f /tmp/app-deploy.tar.gz

echo ""
echo "========================================="
echo "Deployment completed successfully!"
echo "Application is running at: http://$SERVER_HOST"
echo "========================================="
