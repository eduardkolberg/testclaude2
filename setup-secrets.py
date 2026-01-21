#!/usr/bin/env python3
"""
Script to set up GitHub repository secrets for deployment.
Requires a GitHub Personal Access Token with 'repo' scope.
"""

import requests
import json
import sys
import base64
from nacl import encoding, public

def get_public_key(repo, token):
    """Get repository public key for encrypting secrets."""
    url = f"https://api.github.com/repos/{repo}/actions/secrets/public-key"
    headers = {
        "Authorization": f"token {token}",
        "Accept": "application/vnd.github.v3+json"
    }
    response = requests.get(url, headers=headers)
    response.raise_for_status()
    return response.json()

def encrypt_secret(public_key: str, secret_value: str) -> str:
    """Encrypt a secret using the repository's public key."""
    public_key_obj = public.PublicKey(public_key.encode("utf-8"), encoding.Base64Encoder())
    sealed_box = public.SealedBox(public_key_obj)
    encrypted = sealed_box.encrypt(secret_value.encode("utf-8"))
    return base64.b64encode(encrypted).decode("utf-8")

def set_secret(repo, token, secret_name, secret_value, key_id, public_key):
    """Set a repository secret."""
    url = f"https://api.github.com/repos/{repo}/actions/secrets/{secret_name}"
    headers = {
        "Authorization": f"token {token}",
        "Accept": "application/vnd.github.v3+json"
    }
    encrypted_value = encrypt_secret(public_key, secret_value)
    data = {
        "encrypted_value": encrypted_value,
        "key_id": key_id
    }
    response = requests.put(url, headers=headers, json=data)
    response.raise_for_status()
    return response.status_code

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 setup-secrets.py <GITHUB_TOKEN>")
        sys.exit(1)

    token = sys.argv[1]
    repo = "eduardkolberg/testclaude2"

    # Get public key
    print("Getting repository public key...")
    key_data = get_public_key(repo, token)
    key_id = key_data["key_id"]
    public_key = key_data["key"]

    # Set secrets
    secrets = {
        "SSH_HOST": "49.13.52.51",
        "SSH_USER": "root",
        "SSH_PASSWORD": "hvccuefb3qC4CuUmaHpc"
    }

    for name, value in secrets.items():
        print(f"Setting secret {name}...")
        set_secret(repo, token, name, value, key_id, public_key)
        print(f"✓ Secret {name} set successfully")

    print("\nAll secrets configured successfully!")

if __name__ == "__main__":
    main()
