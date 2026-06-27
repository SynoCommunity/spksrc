---
title: DNSCrypt-Proxy
description: DNS encryption and privacy proxy
tags:
  - network
  - security
  - dns
  - privacy
---

# DNSCrypt-Proxy

DNSCrypt-proxy provides DNS encryption, prevents DNS spoofing, and blocks ads and malware.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | dnscrypt-proxy |
| Upstream | [github.com/DNSCrypt/dnscrypt-proxy](https://github.com/DNSCrypt/dnscrypt-proxy) |
| License | ISC |
| Default Port | 53 (DNS) |

## Features

- DNS over HTTPS (DoH)
- DNS over TLS
- DNSCrypt protocol
- DNSSEC validation
- Blocklists (ads, malware)
- Caching
- Load balancing

## Installation

1. Install DNSCrypt-Proxy from Package Center
2. Configure settings as needed
3. Point devices to use NAS as DNS server

## Configuration

### Configuration File

Main config: `/var/packages/dnscrypt-proxy/var/dnscrypt-proxy.toml`

### Basic Settings

```toml
listen_addresses = ['0.0.0.0:53']
server_names = ['cloudflare', 'google']

# Enable caching
cache = true
cache_size = 4096
```

### Blocklists

```toml
[blocked_names]
blocked_names_file = '/var/packages/dnscrypt-proxy/var/blocked-names.txt'

[blocked_ips]
blocked_ips_file = '/var/packages/dnscrypt-proxy/var/blocked-ips.txt'
```

### Using Custom Servers

```toml
[static]
[static.'myresolver']
stamp = 'sdns://...'
```

## Network Configuration

### Using as Network DNS

1. Configure your router's DHCP to distribute NAS IP as DNS
2. Or manually set DNS on each device

### Port Conflict

DSM may use port 53. Options:
- Use alternative port (e.g., 5353) and configure forwarding
- Disable DSM's DNS if not using it

## Testing

```bash
# Test DNS resolution
dig @localhost example.com

# Check if using encrypted DNS
dig @localhost debug.opendns.com TXT
```

## Related Packages

- HAProxy - Can work with DNS load balancing
