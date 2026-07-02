---
title: Vaultwarden
description: Bitwarden-compatible password manager server
tags:
  - security
  - password
  - web
---

# Vaultwarden

Vaultwarden (formerly bitwarden_rs) is an alternative implementation of the Bitwarden server API written in Rust, perfect for self-hosted deployment.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | vaultwarden |
| Upstream | [github.com/dani-garcia/vaultwarden](https://github.com/dani-garcia/vaultwarden) |
| License | AGPL-3.0 |
| Default Port | 8100 |

## Installation

1. Install Vaultwarden from Package Center
2. Access web interface at `http://your-nas:8100`
3. Create your first account

## Configuration

### Data Location

- Data directory: `/var/packages/vaultwarden/var/`
- Configuration: `/var/packages/vaultwarden/var/config.env`
- Database: `/var/packages/vaultwarden/var/db.sqlite3`

### Admin Panel

To enable the admin panel:

1. Generate an admin token: `openssl rand -base64 48`
2. Add to config.env: `ADMIN_TOKEN=your_generated_token`
3. Restart the package
4. Access admin at `http://your-nas:8100/admin`

### HTTPS Setup

Vaultwarden should be accessed over HTTPS. Options:

1. **DSM Reverse Proxy** (recommended) - Application Portal → Reverse Proxy
2. **External reverse proxy** - Use HAProxy, nginx, or Cloudflared

## Backup

Back up these files regularly:

- `/var/packages/vaultwarden/var/db.sqlite3` - Main database
- `/var/packages/vaultwarden/var/attachments/` - File attachments
- `/var/packages/vaultwarden/var/rsa_key*` - RSA keys

## Troubleshooting

### Cannot Connect from Browser Extension

Bitwarden clients require HTTPS with a valid certificate. Configure a reverse proxy with SSL.

### Database Locked

If you see "database is locked" errors, ensure only one Vaultwarden instance is running.

## Related Packages

- [Cloudflared](cloudflared.md) - Secure tunnel access
