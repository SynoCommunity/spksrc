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
| Default Port | 8180 |

## Installation

1. Install Vaultwarden from Package Center
2. [Configure a reverse proxy with HTTPS](#https-setup) — required for the web vault and Bitwarden clients
3. Access the web vault at `https://your-domain.com` and create your first account
4. (Optional) Access the admin panel at `http://your-nas:8180/admin` — works over local HTTP

## Configuration

### Data Location

- Data directory: `/var/packages/vaultwarden/var/`
- Environment configuration: `/var/packages/vaultwarden/var/.env`
- Runtime configuration: `/var/packages/vaultwarden/var/config.json` (editable via admin UI)
- Database: `/var/packages/vaultwarden/var/db.sqlite3`

### Database Support

Vaultwarden supports multiple database backends:

- **SQLite** (default) — No additional configuration needed
- **MySQL/MariaDB** — Set `DATABASE_URL` in `.env`
- **PostgreSQL** — Set `DATABASE_URL` in `.env`

### Admin Panel

To enable the admin panel:

1. Generate an admin token: `openssl rand -base64 48`
2. Add to `.env`: `ADMIN_TOKEN=your_generated_token`
3. Restart the package
4. Access admin at `http://your-nas:8180/admin`

If you didn't copy the token during installation and want to disable admin access, edit `/var/packages/vaultwarden/var/config.json` and set:

```json
"disable_admin_token": true
```

### HTTPS Setup

!!! warning
    Vaultwarden uses the **Web Crypto API** which requires a secure context (HTTPS). The web vault and Bitwarden clients require HTTPS — only the admin panel works over plain HTTP. Configure a reverse proxy with SSL before using the web vault.

#### Step 1: Create a Certificate (if needed)

- Go to **Control Panel** > **Security** > **Certificate**
- Add a certificate via Let's Encrypt or import your own

#### Step 2: Create Reverse Proxy Entry

Navigate to the Reverse Proxy settings:

- **DSM 7**: **Control Panel** > **Login Portal** > **Advanced** > **Reverse Proxy**
- **DSM 6**: **Control Panel** > **Application Portal** > **Reverse Proxy**

Click **Create** and configure as follows:

| Field | Value |
|-------|-------|
| **Description** | Vaultwarden |
| **Source Protocol** | HTTPS |
| **Source Hostname** | Your domain (e.g., `vault.yourdomain.com`) |
| **Source Port** | 443 (or custom) |
| **Destination Protocol** | HTTP |
| **Destination Hostname** | localhost |
| **Destination Port** | 8180 |

#### Step 3: Enable WebSocket Support

WebSocket is required for live sync between Bitwarden clients.

1. In the reverse proxy entry, go to the **Custom Header** tab
2. Click **Create** > **WebSocket**
3. Click **Save** to apply the configuration

#### Step 4: Assign Certificate

- Go to **Control Panel** > **Security** > **Certificate**
- Click **Settings** (DSM 7) or **Configure** (DSM 6)
- Assign your certificate to the Vaultwarden reverse proxy entry

#### Alternative: Built-in TLS

If you prefer not to use a reverse proxy, Vaultwarden supports built-in TLS:

1. Generate or obtain SSL certificates (e.g., via Let's Encrypt)
2. Edit the environment file: `/var/packages/vaultwarden/var/.env`
3. Add or uncomment:

    ```
    ROCKET_TLS={certs="/path/to/certs.pem",key="/path/to/key.pem"}
    ```

4. Restart the package

### Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 8180 | TCP | Web interface and API |

## Backup

Back up these files regularly:

- `/var/packages/vaultwarden/var/db.sqlite3` — Main database
- `/var/packages/vaultwarden/var/attachments/` — File attachments
- `/var/packages/vaultwarden/var/rsa_key*` — RSA keys

## Troubleshooting

### Cannot Connect from Browser Extension

Bitwarden clients require HTTPS with a valid certificate. See the [reverse proxy setup](#https-setup) above.

### WebSocket Connection Errors

Make sure WebSocket headers are configured in your reverse proxy — see [Step 3](#step-3-enable-websocket-support).

### Database Locked

If you see "database is locked" errors, ensure only one Vaultwarden instance is running.

### Connection Refused

Check that the package is running: **Package Center** > **Vaultwarden** > **Run**

## Related Packages

- [Cloudflared](cloudflared.md) — Secure tunnel access

## External Resources

- [Vaultwarden Wiki](https://github.com/dani-garcia/vaultwarden/wiki)
- [Bitwarden Help Center](https://bitwarden.com/help/)
