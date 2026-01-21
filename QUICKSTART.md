# Quick Start Guide

Get your Hello World application deployed in 3 minutes!

## Step 1: Configure GitHub Secrets

Run this command in your terminal:

```bash
gh auth login && \
echo "49.13.52.51" | gh secret set SSH_HOST -R eduardkolberg/testclaude2 && \
echo "root" | gh secret set SSH_USER -R eduardkolberg/testclaude2 && \
echo "hvccuefb3qC4CuUmaHpc" | gh secret set SSH_PASSWORD -R eduardkolberg/testclaude2 && \
echo "✓ Secrets configured successfully!"
```

**Don't have `gh` CLI?** [Install it here](https://cli.github.com/manual/installation)

## Step 2: Trigger Deployment

### Option A: Push to trigger automatic deployment
```bash
git push origin claude/hello-world-github-actions-9IxaD
```

### Option B: Manual trigger via GitHub UI
1. Go to https://github.com/eduardkolberg/testclaude2/actions
2. Click on "Deploy to Server" workflow
3. Click "Run workflow" button
4. Select your branch and click "Run workflow"

### Option C: Use manual workflow with inputs
1. Go to https://github.com/eduardkolberg/testclaude2/actions
2. Click on "Deploy to Server (Manual)" workflow
3. Click "Run workflow" button
4. Enter credentials:
   - SSH Host: `49.13.52.51`
   - SSH User: `root`
   - SSH Password: `hvccuefb3qC4CuUmaHpc`
5. Click "Run workflow"

## Step 3: Access Your Application

Once deployment completes (check Actions tab for progress), visit:

### http://49.13.52.51

You should see "Hello World" displayed on the page!

---

## Troubleshooting

### "gh: command not found"

Install GitHub CLI:
- **macOS**: `brew install gh`
- **Linux**: See https://github.com/cli/cli/blob/trunk/docs/install_linux.md
- **Windows**: `winget install GitHub.cli`

### "Not authenticated with GitHub"

Run `gh auth login` and follow the prompts.

### "Cannot connect to server"

The server might need to be set up first. GitHub Actions will automatically:
- Install Docker
- Install Git
- Configure the environment
- Deploy the application

Just trigger the workflow and wait for it to complete!

### Deployment stuck or failing?

1. Check the Actions tab for detailed logs
2. Verify server is accessible from internet
3. Ensure SSH port 22 is open
4. Try the manual deployment option (Option C above)

---

## Alternative: Deploy from Local Machine

If GitHub Actions has network issues accessing your server, you can deploy directly:

```bash
chmod +x deploy-direct.sh
./deploy-direct.sh
```

This requires network access from your machine to the server.

---

**Questions?** Check [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md) for detailed documentation.
