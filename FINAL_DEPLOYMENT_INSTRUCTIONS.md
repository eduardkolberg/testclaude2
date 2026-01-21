# 🎯 FINAL DEPLOYMENT INSTRUCTIONS

## ✅ What's Ready

All code has been written, committed, and pushed to GitHub:

- ✅ Node.js Hello World application
- ✅ Docker configuration
- ✅ GitHub Actions workflows (3 variants)
- ✅ Automated server setup scripts
- ✅ Bootstrap workflow for one-click deployment

**Repository**: https://github.com/eduardkolberg/testclaude2
**Branch**: `claude/hello-world-github-actions-9IxaD`

## 🚀 DEPLOY NOW (Choose One Method)

### 🥇 Method 1: One-Click Deployment (EASIEST - 2 Minutes)

**This is the recommended method!**

1. **Click this link**: https://github.com/eduardkolberg/testclaude2/actions/workflows/bootstrap-secrets.yml

2. **Click the green "Run workflow" button** (top right)

3. **Fill in the form**:
   ```
   Branch: claude/hello-world-github-actions-9IxaD
   SSH Host: 49.13.52.51
   SSH User: root
   SSH Password: hvccuefb3qC4CuUmaHpc
   Setup type: deploy_now
   ```

4. **Click "Run workflow"**

5. **Wait 2-3 minutes** - watch the Actions tab for progress

6. **Done!** Visit **http://49.13.52.51** to see "Hello World"!

### 🥈 Method 2: Using GitHub CLI

```bash
# Install GitHub CLI if needed
# macOS: brew install gh
# Linux: see https://cli.github.com/manual/installation

# Authenticate
gh auth login

# Run deployment
gh workflow run bootstrap-secrets.yml \
  --repo eduardkolberg/testclaude2 \
  --ref claude/hello-world-github-actions-9IxaD \
  --field ssh_host="49.13.52.51" \
  --field ssh_user="root" \
  --field ssh_password="hvccuefb3qC4CuUmaHpc" \
  --field setup_type="deploy_now"

# Check status
gh run list --workflow=bootstrap-secrets.yml --limit 1

# View logs
gh run view --log
```

### 🥉 Method 3: Using cURL (Advanced)

```bash
# First, create a GitHub Personal Access Token:
# https://github.com/settings/tokens/new
# Scopes needed: repo, workflow

# Then run:
export GITHUB_TOKEN="your_token_here"

curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/eduardkolberg/testclaude2/actions/workflows/bootstrap-secrets.yml/dispatches \
  -d '{
    "ref": "claude/hello-world-github-actions-9IxaD",
    "inputs": {
      "ssh_host": "49.13.52.51",
      "ssh_user": "root",
      "ssh_password": "hvccuefb3qC4CuUmaHpc",
      "setup_type": "deploy_now"
    }
  }'
```

## 🎯 What Happens During Deployment

The Bootstrap workflow will automatically:

1. ✅ Configure GitHub Secrets (SSH_HOST, SSH_USER, SSH_PASSWORD)
2. ✅ Connect to server 49.13.52.51 via SSH
3. ✅ Install Docker (if not present)
4. ✅ Install Git (if not present)
5. ✅ Clone repository to `/opt/hello-world-app`
6. ✅ Build Docker image
7. ✅ Start container on port 80
8. ✅ Verify deployment

**Total time**: ~2-3 minutes

## 📊 Monitor Deployment

Watch the deployment progress:
https://github.com/eduardkolberg/testclaude2/actions

You'll see:
- 🟡 Yellow dot = Running
- ✅ Green checkmark = Success
- ❌ Red X = Failed (check logs)

## 🎉 Access Your Application

Once deployment is complete (green checkmark):

### 🌐 http://49.13.52.51

You should see: **Hello World**

## 🔄 Future Deployments

After the initial bootstrap:

1. **Automatic**: Just push to branch - deployment happens automatically
2. **Manual**: Run "Deploy to Server" workflow from Actions tab
3. **Direct**: Run `./deploy-direct.sh` if you have network access to server

## 📝 Available Workflows

1. **bootstrap-secrets.yml**: One-click setup + deploy (use this first!)
2. **deploy.yml**: Auto-deploys on push to main/claude/* branches
3. **deploy-manual.yml**: Manual deployment with runtime inputs

## 🛠 Troubleshooting

### "Workflow not found"
- Make sure you're on the correct repository: eduardkolberg/testclaude2
- Check that the branch `claude/hello-world-github-actions-9IxaD` exists

### "Deployment failed"
- Check Actions tab for detailed error logs
- Verify server 49.13.52.51 is accessible from internet
- Ensure SSH port 22 is open on server

### "Can't access application"
- Wait 30 seconds after deployment completes
- Try http://49.13.52.51 (not https)
- Check if Docker container is running: `ssh root@49.13.52.51 "docker ps"`

### Need Help?
- Check [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md) for detailed docs
- Review workflow logs in Actions tab
- Verify all credentials are correct

## 🎯 Quick Reference

- **Server IP**: 49.13.52.51
- **Application URL**: http://49.13.52.51
- **Repository**: https://github.com/eduardkolberg/testclaude2
- **Branch**: claude/hello-world-github-actions-9IxaD
- **Deployment Time**: ~2-3 minutes

## 🚦 Status Check

After deployment, verify:

```bash
# Check if container is running
ssh root@49.13.52.51 "docker ps | grep hello-world-app"

# Check application logs
ssh root@49.13.52.51 "docker logs hello-world-app"

# Test application
curl http://49.13.52.51
```

Should return HTML with "Hello World"!

---

**Ready? Start with Method 1 (One-Click Deployment)** ⬆️
