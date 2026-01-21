#!/bin/bash
set -e

echo "Setting up server environment..."

# Update system
apt-get update
apt-get upgrade -y

# Install Docker
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    systemctl enable docker
    systemctl start docker
fi

# Install git
if ! command -v git &> /dev/null; then
    echo "Installing git..."
    apt-get install -y git
fi

# Configure firewall
if command -v ufw &> /dev/null; then
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw allow 22/tcp
    echo "y" | ufw enable || true
fi

echo "Server setup completed!"
docker --version
git --version
