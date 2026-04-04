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

1. Install cloudflared from Package Center
2. Authenticate with Cloudflare (see Configuration)
3. Create and configure your tunnel

## Configuration

### Initial Authentication

SSH to your NAS and run:

```bash
/var/packages/cloudflared/target/bin/cloudflared tunnel login
```

This generates a certificate at `~/.cloudflared/cert.pem`.

### Create a Tunnel

```bash
/var/packages/cloudflared/target/bin/cloudflared tunnel create my-tunnel
```

### Configure the Tunnel

Create `/var/packages/cloudflared/var/config.yml`:

```yaml
tunnel: <tunnel-id>
credentials-file: /var/packages/cloudflared/var/.cloudflared/<tunnel-id>.json

ingress:
  - hostname: service.yourdomain.com
    service: http://localhost:8080
  - service: http_status:404
```

### DNS Configuration

```bash
/var/packages/cloudflared/target/bin/cloudflared tunnel route dns my-tunnel service.yourdomain.com
```

## Service Management

- Start: Package Center or `synopkg start cloudflared`
- Stop: Package Center or `synopkg stop cloudflared`
- Logs: `/var/packages/cloudflared/var/log/`

## Troubleshooting

### Tunnel Not Connecting

1. Verify credentials file exists
2. Check DNS routing is configured
3. Review logs in `/var/packages/cloudflared/var/log/`

## Related Packages

- [Vaultwarden](vaultwarden.md) - Common use case for tunnels
- [Home Assistant](homeassistant.md) - Remote access via tunnel
