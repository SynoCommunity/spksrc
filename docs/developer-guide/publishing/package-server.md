---
title: Package Server Setup
description: Setting up your own package repository with spkrepo
tags:
  - publishing
  - spkrepo
  - repository
---

# Package Server Setup

You can host your own package repository using [spkrepo](https://github.com/SynoCommunity/spkrepo), the same software that powers the SynoCommunity package server.

!!! tip "Reference Documentation"
    For the most up-to-date setup instructions, see the [spkrepo README](https://github.com/SynoCommunity/spkrepo#readme).

## Overview

A package server provides:

- **Package Index** - Machine-readable catalog for Package Center
- **SPK Hosting** - File downloads for installation
- **Version Management** - Multiple versions per package
- **Architecture Filtering** - Serve appropriate packages per device

## spkrepo Setup

### Prerequisites

- Docker and docker-compose
- [uv](https://github.com/astral-sh/uv) (Python package manager)
- SSL certificate (required for DSM 7+ clients)

### Quick Start

Using Docker (recommended):

```bash
# Clone spkrepo
git clone https://github.com/SynoCommunity/spkrepo.git
cd spkrepo

# Run with docker-compose
docker compose up
```

The server will be available at:
- Website: http://localhost:5000
- Admin: http://localhost:5000/admin
- NAS API: http://localhost:5000/nas

### Development Setup

```bash
# Clone spkrepo
git clone https://github.com/SynoCommunity/spkrepo.git
cd spkrepo

# Start postgres database
docker compose up db

# Install dependencies with uv
uv sync

# Initialize database
uv run flask db upgrade

# Create admin user
uv run flask spkrepo create_admin -u admin -e admin@example.com -p yourpassword

# Run development server
uv run flask run
```

### Production Deployment

For production, use the Docker image with nginx:

```bash
docker run -it --rm --name spkrepo \
  -v $(pwd)/data:/data \
  -v $(pwd)/config.py:/config.py \
  -e SPKREPO_CONFIG=/config.py \
  -p 8000:8000 \
  ghcr.io/synocommunity/spkrepo
```

Example nginx reverse proxy:

```nginx
server {
    listen 443 ssl http2;
    server_name packages.example.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /packages {
        alias /path/to/spkrepo/packages;
        autoindex on;
    }
}
```

## Adding Packages

### Manual Upload

Use the admin web interface at `/admin` to upload and manage packages.

### Automated Publishing

For CI/CD integration:

```bash
# API upload (requires auth token)
curl -X POST \
  -H "Authorization: Bearer ${SPKREPO_TOKEN}" \
  -F "file=@package.spk" \
  https://packages.example.com/api/upload
```

## Client Configuration

### Adding Repository to DSM

1. Open **Package Center**
2. Go to **Settings** > **Package Sources**
3. Click **Add**
4. Enter:
    - **Name**: Your Repository Name
    - **Location**: `https://packages.example.com`
5. Click **OK**

### Trust Settings (DSM 6.x Only)

1. Go to **Settings** > **General**
2. Set **Trust Level** to "Synology Inc. and trusted publishers"

## Package Signing

### DSM Version Differences

- **DSM 6.x**: Package signing ensures that packages are recognized as coming from a trusted publisher. Users must configure their trust level settings to allow installation of packages signed by Synology Inc. and trusted publishers.
- **DSM 7+**: Only Synology-signed packages are trusted. All community packages will always show a third-party warning during installation, regardless of signing. Package signing has no effect on DSM 7+.

### Signing for DSM 6.x

Synology provides CodeSign service for verified developers:

1. Apply at [Synology Developer Center](https://www.synology.com/en-us/support/developer)
2. Receive signing certificate
3. Configure spksrc with certificate path
4. Packages are signed during build

## Repository Structure

A package server provides this endpoint structure:

```
/                           # Repository root
├── packages/               # SPK file storage
│   ├── transmission/
│   │   ├── transmission_x64-7.2_4.0.5-11.spk
│   │   └── transmission_aarch64-7.2_4.0.5-11.spk
│   └── ...
└── api/                    # Package Center API
    └── package             # JSON catalog endpoint
```

### Catalog API Response

Package Center queries `/api/package` with device info:

```
GET /api/package?arch=x64&model=DS920%2B&major=7&minor=2&build=64570
```

Response:

```json
{
  "packages": [
    {
      "package": "transmission",
      "version": "4.0.5-11",
      "dname": "Transmission",
      "desc": "BitTorrent client",
      "link": "https://packages.example.com/packages/transmission/...",
      "thumbnail": [...],
      ...
    }
  ]
}
```

## Testing Your Repository

### Verify Catalog

```bash
# Test API endpoint
curl "https://packages.example.com/api/package?arch=x64&major=7&minor=2"

# Check package download
curl -I "https://packages.example.com/packages/mypackage/mypackage_x64-7.2_1.0.0-1.spk"
```

### DSM Testing

1. Add repository to test DSM
2. Check Package Center shows your packages
3. Install and verify functionality
4. Test updates by incrementing version

## Troubleshooting

### Packages Not Appearing

- Verify architecture matches device
- Check DSM version compatibility (`os_min_ver`)
- Ensure SSL certificate is valid
- Check server logs for API errors

### Installation Failures

- Verify SPK file integrity
- Check package signature if required
- Review DSM package logs

## See Also

- [Publishing Overview](index.md)
- [GitHub Actions CI/CD](github-actions.md)
- [spkrepo GitHub Repository](https://github.com/SynoCommunity/spkrepo)
