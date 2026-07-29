---
title: Netdata
description: Real-time performance and health monitoring platform
tags:
  - monitoring
  - system
  - observability
---

# Netdata

[Netdata](https://www.netdata.cloud) provides real-time performance and health monitoring for your DiskStation with an interactive web dashboard.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | netdata |
| Upstream | [github.com/netdata/netdata](https://github.com/netdata/netdata) |
| License | GPLv3 |

## Prerequisites

- DSM 7.0 or newer
- For per-process disk I/O monitoring: SSH access (see Post-Install)

## Installation

Install netdata from Package Center. The web dashboard is available at `http://your-nas:19999` and appears in the DSM main menu.

## Post-Install

### Enable Process Monitoring (Optional)

Per-process disk I/O monitoring requires `apps.plugin` to run with elevated privileges. DSM 7 blocks setuid binaries from unsigned packages, so this must be applied manually after install:

```bash
netdata-fix
```

This prompts for your DSM password, applies the fix, and tells you to restart the package. It only needs to be run once per install or upgrade.

### Verify It's Running

```bash
synopkg status netdata
```

The dashboard at `http://your-nas:19999` should load immediately.

## Configuration

### Netdata Cloud

To connect this node to Netdata Cloud for multi-node monitoring:

1. Go to `http://your-nas:19999` and click **Sign In** or **Sign Up**
2. Follow the on-screen prompts to claim the node

### Stock vs User Config

Netdata ships with a complete stock configuration at `/var/packages/netdata/target/usr/lib/netdata/conf.d/`. User overrides can be placed in `/var/packages/netdata/var/etc/netdata/`.

## Runtime Data Locations

| Data | Location |
|------|----------|
| Configuration (user) | `/var/packages/netdata/var/etc/netdata/` |
| Database | `/var/packages/netdata/var/cache/netdata/dbengine/` |
| Logs | `/var/packages/netdata/var/log/netdata/` |
| Registry/GUID | `/var/packages/netdata/var/lib/netdata/` |

## Service Management

- Start: Package Center or `synopkg start netdata`
- Stop: Package Center or `synopkg stop netdata`
- Logs: `/var/packages/netdata/var/log/netdata/` and `/var/packages/netdata/var/netdata.log`

## Troubleshooting

### Disk I/O not showing per process

Run `netdata-fix` from SSH, then restart the package.


