#!/bin/bash
set -e

echo "========================================="
echo "Direct Server Setup and Deployment"
echo "========================================="
echo ""

SERVER_HOST="49.13.52.51"
SERVER_USER="root"
SERVER_PASS="hvccuefb3qC4CuUmaHpc"

echo "Testing connection to server..."

# Test SSH connection with timeout
if ! timeout 15 sshpass -p "$SERVER_PASS" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 "$SERVER_USER@$SERVER_HOST" "echo 'Connection successful'" 2>/dev/null; then
    echo "❌ ERROR: Cannot connect to server $SERVER_HOST"
    echo ""
    echo "Possible issues:"
    echo "1. Server is not accessible from this network"
    echo "2. SSH port (22) is blocked by firewall"
    echo "3. Server credentials are incorrect"
    echo "4. Server is down"
    echo ""
    echo "Please check:"
    echo "- Can you access server from your network?"
    echo "- Is SSH port 22 open?"
    echo "- Try: ssh root@$SERVER_HOST"
    echo ""
    exit 1
fi

echo "✓ Connection successful!"
echo ""
echo "Starting deployment..."
echo ""

# Create deployment script on server
sshpass -p "$SERVER_PASS" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_HOST" bash << 'REMOTE_SCRIPT'
set -e

echo "Step 1: Updating system..."
apt-get update -qq

echo "Step 2: Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sh /tmp/get-docker.sh
    systemctl enable docker
    systemctl start docker
    echo "✓ Docker installed"
else
    echo "✓ Docker already installed"
fi

echo "Step 3: Installing Git..."
if ! command -v git &> /dev/null; then
    apt-get install -y git
    echo "✓ Git installed"
else
    echo "✓ Git already installed"
fi

echo "Step 4: Cloning repository..."
mkdir -p /opt/hello-world-app
cd /opt/hello-world-app

if [ -d .git ]; then
    echo "Repository exists, updating..."
    git fetch --all
    git reset --hard origin/claude/hello-world-github-actions-9IxaD
    git pull origin claude/hello-world-github-actions-9IxaD
else
    echo "Cloning repository..."
    git clone -b claude/hello-world-github-actions-9IxaD https://github.com/eduardkolberg/testclaude2 .
fi

echo "✓ Repository ready"

echo "Step 5: Stopping existing container..."
docker stop hello-world-app 2>/dev/null || echo "No existing container"
docker rm hello-world-app 2>/dev/null || echo "No container to remove"

echo "Step 6: Building Docker image..."
docker build -t hello-world-app:latest .

echo "Step 7: Starting application..."
docker run -d \
  --name hello-world-app \
  --restart unless-stopped \
  -p 80:3000 \
  hello-world-app:latest

echo "Step 8: Verifying deployment..."
sleep 5

if docker ps | grep -q hello-world-app; then
    echo "✓ Container is running"
    docker ps | grep hello-world-app
    echo ""
    echo "✓ Testing application..."
    sleep 2
    if curl -f http://localhost:80 > /dev/null 2>&1; then
        echo "✓ Application is responding"
    else
        echo "⚠ Warning: Application may not be responding yet"
        echo "Check logs: docker logs hello-world-app"
    fi
else
    echo "❌ Container failed to start"
    echo "Logs:"
    docker logs hello-world-app 2>&1 || true
    exit 1
fi

REMOTE_SCRIPT

echo ""
echo "========================================="
echo "✓ DEPLOYMENT SUCCESSFUL!"
echo "========================================="
echo ""
echo "Your application is now running at:"
echo ""
echo "    🌐 http://$SERVER_HOST"
echo ""
echo "You should see 'Hello World' on the page!"
echo ""
echo "Useful commands:"
echo "  Check status: ssh root@$SERVER_HOST 'docker ps'"
echo "  View logs:    ssh root@$SERVER_HOST 'docker logs hello-world-app'"
echo "  Restart:      ssh root@$SERVER_HOST 'docker restart hello-world-app'"
echo ""
