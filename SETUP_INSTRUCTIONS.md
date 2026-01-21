# Deployment Setup Instructions

This document provides step-by-step instructions for deploying the Hello World application to your server.

## Prerequisites

- GitHub account with access to this repository
- Server credentials (already configured for: 49.13.52.51)

## Option 1: Automated Deployment via GitHub Actions (Recommended)

### Step 1: Configure GitHub Secrets

You need to add three secrets to your GitHub repository:

#### Using GitHub CLI (Fastest):

```bash
# Install gh CLI if not installed
# https://cli.github.com/manual/installation

# Login to GitHub
gh auth login

# Navigate to repository directory
cd /path/to/testclaude2

# Set secrets
echo "49.13.52.51" | gh secret set SSH_HOST
echo "root" | gh secret set SSH_USER
echo "hvccuefb3qC4CuUmaHpc" | gh secret set SSH_PASSWORD

# Verify secrets are set
gh secret list
```

#### Using GitHub Web Interface:

1. Go to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each of the following secrets:
   - Name: `SSH_HOST`, Value: `49.13.52.51`
   - Name: `SSH_USER`, Value: `root`
   - Name: `SSH_PASSWORD`, Value: `hvccuefb3qC4CuUmaHpc`

### Step 2: Trigger Deployment

Once secrets are configured, the deployment will happen automatically when you push to the `main` or `claude/*` branches.

To manually trigger deployment:
1. Go to **Actions** tab in GitHub
2. Select **Deploy to Server** workflow
3. Click **Run workflow**

## Option 2: Manual Deployment with Workflow Dispatch

If you don't want to set up secrets, you can use the manual deployment workflow:

1. Go to **Actions** tab in GitHub
2. Select **Deploy to Server (Manual)** workflow
3. Click **Run workflow**
4. Enter the server credentials when prompted:
   - SSH Host: `49.13.52.51`
   - SSH User: `root`
   - SSH Password: `hvccuefb3qC4CuUmaHpc`
5. Click **Run workflow**

## Option 3: Direct Deployment from Local Machine

If you have network access to the server, you can deploy directly:

```bash
chmod +x deploy-direct.sh
./deploy-direct.sh
```

This will:
- Install Docker on the server
- Build and deploy the application
- Start the application on port 80

## Accessing the Application

Once deployed, the application will be available at:

**http://49.13.52.51**

## Troubleshooting

### Deployment fails with "Connection refused"

- Check if the server is accessible from GitHub Actions
- Verify SSH is enabled on the server
- Check firewall rules allow incoming connections on port 22

### Application not accessible after deployment

- Check if Docker container is running: `docker ps`
- View container logs: `docker logs hello-world-app`
- Verify port 80 is accessible from external networks

### GitHub Actions workflow fails

- Check the Actions tab for detailed error logs
- Verify all secrets are correctly set
- Ensure the repository has the latest code

## Quick Setup Script

For quick setup using GitHub CLI:

```bash
#!/bin/bash
# Run this script to set up everything automatically

# Authenticate with GitHub
gh auth login

# Set secrets
echo "49.13.52.51" | gh secret set SSH_HOST -R eduardkolberg/testclaude2
echo "root" | gh secret set SSH_USER -R eduardkolberg/testclaude2
echo "hvccuefb3qC4CuUmaHpc" | gh secret set SSH_PASSWORD -R eduardkolberg/testclaude2

echo "Secrets configured! Push to trigger deployment."
```

## Next Steps

1. Configure secrets (choose one of the methods above)
2. Push code to repository or manually trigger workflow
3. Wait for deployment to complete (check Actions tab)
4. Access your application at http://49.13.52.51

The application will show "Hello World" on the screen.
