# Hello World Web Application 🚀

Simple Node.js web application that displays "Hello World" - fully automated deployment to your server!

## ⚡ Quick Start (2 Minutes!)

### One-Click Deployment (Recommended)

1. **Go to Actions**: https://github.com/eduardkolberg/testclaude2/actions/workflows/bootstrap-secrets.yml

2. **Click "Run workflow"**

3. **Fill in the form**:
   - Branch: `claude/hello-world-github-actions-9IxaD`
   - SSH Host: `49.13.52.51`
   - SSH User: `root`
   - SSH Password: `hvccuefb3qC4CuUmaHpc`
   - Setup type: `deploy_now`

4. **Click "Run workflow"** and wait ~2-3 minutes

5. **Done!** Visit **http://49.13.52.51** to see your app! 🎉

## 📋 What's Included

- **Node.js + Express**: Simple web server
- **Docker**: Containerized application
- **GitHub Actions**: Automated CI/CD pipeline
- **Bootstrap Workflow**: One-click setup and deployment
- **Auto-Configuration**: Automatically installs Docker, Git, etc. on server

## 🛠 Features

- Express.js web server
- Docker containerization
- Automated deployment via GitHub Actions
- One-click setup with Bootstrap workflow
- Auto-installs dependencies on server

## 🚀 How It Works

1. **Bootstrap Workflow** receives credentials via inputs
2. Uses GitHub API to create repository secrets
3. Connects to server via SSH
4. Installs Docker and Git if needed
5. Clones repository to `/opt/hello-world-app`
6. Builds Docker image
7. Runs container on port 80
8. Application is live!

## 🔧 Local Development

```bash
npm install
npm start
```

Visit http://localhost:3000

## 📖 Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - Fast deployment guide
- **[SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md)** - Detailed setup documentation

## 🎯 Access Your Application

After successful deployment:

### 🌐 http://49.13.52.51

You should see "Hello World" displayed on the page!

## 🐛 Troubleshooting

Check the [Actions](https://github.com/eduardkolberg/testclaude2/actions) tab for deployment status and logs.

For detailed troubleshooting, see [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md)
