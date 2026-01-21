# Hello World Web Application

Simple Node.js web application that displays "Hello World".

## Features

- Express.js web server
- Docker containerization
- Automated deployment via GitHub Actions

## Local Development

```bash
npm install
npm start
```

Visit http://localhost:3000

## Deployment

The application automatically deploys to the server when changes are pushed to the main branch.

### Required GitHub Secrets

Add these secrets in your GitHub repository settings:

- `SSH_HOST`: Server IP address
- `SSH_USER`: SSH username
- `SSH_PASSWORD`: SSH password

## Server Setup

Run on the server to prepare the environment:

```bash
chmod +x setup-server.sh
./setup-server.sh
```

## Access

After deployment, the application is available at: http://49.13.52.51
