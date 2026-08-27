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

### Enable Elevated-Privilege Features (Optional)

Per-process monitoring, system log browsing, the network connections view, and automatic service discovery require elevated privileges. DSM 7 blocks setuid binaries from unsigned packages, so this must be applied manually after install:

```bash
netdata-fix
```

This prompts for your DSM password when needed, grants root privileges to the underlying plugins, and restarts the package. It only needs to be run once per install or upgrade.

After running it, per-process monitoring appears under **Metrics**, system journal logs are browsable under **Logs**, the network connections view is available, and services (e.g. databases, web servers) are monitored automatically via service discovery.

### Service Discovery on Synology

Service discovery auto-starts collectors for services it finds listening. On DSM, some discovered services may show as failed: DSM's nginx does not expose the `stub_status` endpoint the collector requires, and DSM's PostgreSQL requires credentials the auto-generated job does not have. Such jobs can be disabled or reconfigured from **Collectors → go.d** in the web UI.

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

Run `netdata-fix` from SSH. It grants the needed root privileges and restarts the package for you.

### System logs not appearing

Run `netdata-fix` from SSH. The `systemd-journal.plugin` needs root privileges (via setuid) to read the journal files, which DSM blocks for unsigned packages until the fix is applied.

### Network connections view not showing

Run `netdata-fix` from SSH. The `network-viewer.plugin` needs root privileges (via setuid) to enumerate all sockets and attribute them to processes, which DSM blocks for unsigned packages until the fix is applied.

### Service discovery / go.d collectors not starting

Run `netdata-fix` from SSH. The `ndsudo` helper needs root privileges (via setuid) for the go.d collectors and the listening-socket-based service discovery, which DSM blocks for unsigned packages until the fix is applied.


