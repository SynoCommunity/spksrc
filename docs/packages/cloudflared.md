---
title: Cloudflared
description: Cloudflare Tunnel client for secure remote access
tags:
  - network
  - security
  - tunnel
---

# Cloudflared

Cloudflared creates secure tunnels to expose your local services to the internet without opening ports on your router.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | cloudflared |
| Upstream | [developers.cloudflare.com/cloudflare-one/connections/connect-networks/](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) |
| License | Apache-2.0 |

## Prerequisites

- Cloudflare account (free tier available)
- Domain managed by Cloudflare DNS

## Installation

### Method 1: Token-based (Simpler)

1. Follow the [Cloudflare Tunnel Setup Guide](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) steps 1.1–1.5
2. Copy the provided command (e.g. `cloudflared.exe service install <token>`)
3. Extract only the token part (the long alphanumeric string after `install`)
4. Install cloudflared from Package Center
5. Paste the token when prompted during installation

### Method 2: Certificate-based

1. Install cloudflared from Package Center
2. Authenticate with Cloudflare:
   ```bash
   /var/packages/cloudflared/target/bin/cloudflared tunnel login
   ```
3. Create a tunnel:
   ```bash
   /var/packages/cloudflared/target/bin/cloudflared tunnel create my-tunnel
   ```
4. Configure `/var/packages/cloudflared/var/config.yml`:
   ```yaml
   tunnel: <tunnel-id>
   credentials-file: /var/packages/cloudflared/var/.cloudflared/<tunnel-id>.json
   ingress:
     - hostname: service.yourdomain.com
       service: http://localhost:8080
     - service: http_status:404
   ```
5. Configure DNS routing:
   ```bash
   /var/packages/cloudflared/target/bin/cloudflared tunnel route dns my-tunnel service.yourdomain.com
   ```

## Service Management

- Start: Package Center or `synopkg start cloudflared`
- Stop: Package Center or `synopkg stop cloudflared`
- Logs: `/var/packages/cloudflared/var/log/`

## Troubleshooting

### Tunnel Not Connecting

1. Verify your Cloudflare token is correct (alphanumeric, no newlines or spaces)
2. Check DNS routing is configured
3. Review logs in `/var/packages/cloudflared/var/log/`
4. Try reinstalling with **Erase all of the package data files** checked

### Service Stops Unexpectedly

The service may be killed by the OOM (Out of Memory) killer under low memory conditions. Options:

- Monitor memory usage and disable unneeded services
- Add a scheduled task to restart the service periodically:
  ```bash
  synopkg start cloudflared
  ```

### Client Shows as Outdated

Cloudflare supports the previous year of cloudflared releases — the tunnel will continue working even if the version is not the latest. Updates are published when meaningful changes occur.

## Related Packages

- [Vaultwarden](vaultwarden.md) - Common use case for tunnels
- [Home Assistant](homeassistant.md) - Remote access via tunnel
