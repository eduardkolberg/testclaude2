# ⚠️ Server SSH Access Issue Detected

## 🔍 Problem

The server **49.13.52.51** is not accessible via SSH from external networks. This is why the deployment failed.

**Error**: `Connection timed out on port 22`

## 🎯 What Needs to Be Done

You need to configure the server to allow SSH connections. Here are the steps:

### Option 1: Using Hetzner Cloud Panel (Recommended)

If this is a Hetzner server (based on the IP range), follow these steps:

1. **Log in to Hetzner Cloud Console**: https://console.hetzner.cloud/

2. **Select your server** (49.13.52.51)

3. **Check Firewall Settings**:
   - Go to "Firewalls" section
   - Ensure SSH (port 22) is allowed from all IPs (0.0.0.0/0)
   - Add rule if needed:
     - Protocol: TCP
     - Port: 22
     - Source: 0.0.0.0/0 (or your specific IPs)

4. **Check if server is running**:
   - Server status should be "Running"
   - If stopped, click "Power On"

5. **Access via Console**:
   - Click "Console" in the server panel
   - This gives you direct access even if SSH is blocked
   - You can configure firewall from there

### Option 2: Using Hetzner Console (Direct Server Access)

If you can access the server via Hetzner's web console:

```bash
# Check if SSH is running
systemctl status ssh

# Start SSH if not running
systemctl start ssh
systemctl enable ssh

# Check firewall (if using ufw)
ufw status

# Allow SSH through firewall
ufw allow 22/tcp

# Or disable firewall temporarily for testing
ufw disable

# Check if SSH is listening
netstat -tlnp | grep :22
# or
ss -tlnp | grep :22
```

### Option 3: Check iptables Rules

```bash
# Check current iptables rules
iptables -L -n

# If INPUT chain is blocking, add SSH rule
iptables -I INPUT -p tcp --dport 22 -j ACCEPT

# Save rules (Debian/Ubuntu)
iptables-save > /etc/iptables/rules.v4
```

## 🧪 Test SSH Access

After configuring the firewall, test SSH access:

### From Your Local Machine:
```bash
ssh -v root@49.13.52.51
```

### Test with timeout:
```bash
timeout 10 ssh root@49.13.52.51 "echo 'SSH works!'"
```

### Check if port 22 is open:
```bash
nc -zv 49.13.52.51 22
# or
telnet 49.13.52.51 22
```

## ✅ Once SSH is Working

After you've configured SSH access, run one of these commands:

### Method 1: Run deployment script
```bash
cd /home/user/testclaude2
./deploy-now.sh
```

### Method 2: Trigger GitHub Actions again
1. Go to: https://github.com/eduardkolberg/testclaude2/actions/workflows/bootstrap-secrets.yml
2. Click "Run workflow"
3. Fill in the same parameters
4. Click "Run workflow"

## 🔧 Alternative: Deploy Locally First

If you have local network access to the server (e.g., you're on the same network), you can:

1. **Connect via local network** (if server has local IP)
2. **Use Hetzner console** to deploy manually
3. **Set up VPN** to access the server

## 📋 Server Configuration Checklist

- [ ] Server is powered on
- [ ] SSH service is running (`systemctl status ssh`)
- [ ] Port 22 is open in Hetzner Cloud Firewall
- [ ] iptables/ufw allows port 22
- [ ] Server responds to ping (optional, but helpful)
- [ ] SSH connection works: `ssh root@49.13.52.51`

## 🎯 Quick Fix (If You Have Console Access)

If you can access the Hetzner console:

```bash
# Quick firewall fix
apt-get update
apt-get install -y ufw
ufw allow 22/tcp
ufw allow 80/tcp
ufw --force enable

# Verify SSH is running
systemctl restart ssh
systemctl status ssh

# Test locally
curl http://localhost:22 || echo "SSH is listening"
```

## 🆘 Need Help?

**Common issues:**

1. **Firewall blocking**: Most common issue
   - Solution: Add port 22 to firewall rules

2. **Server not running**: Check Hetzner panel
   - Solution: Power on the server

3. **SSH service not installed**: Rare on Hetzner
   - Solution: `apt-get install openssh-server`

4. **Wrong credentials**: Double-check password
   - Solution: Reset password in Hetzner panel

## 📞 Contact Hetzner Support

If you can't resolve this:
- Check Hetzner documentation: https://docs.hetzner.com/
- Contact support: https://www.hetzner.com/support
- Check server status: https://status.hetzner.com/

---

## ⏭️ Next Steps

1. **Fix SSH access** using methods above
2. **Test connection**: `ssh root@49.13.52.51`
3. **Run deployment**: `./deploy-now.sh` or trigger GitHub Actions
4. **Get your URL**: http://49.13.52.51

The application code is ready and waiting to be deployed!
