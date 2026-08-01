---
title: Icinga
description: Icinga 2 monitoring platform with Icinga Web 2 frontend and distributed agents
tags:
  - monitoring
  - icinga
  - observability
---

# Icinga

[Icinga](https://icinga.com) is an open-source monitoring system that checks the availability of your network resources, notifies users of outages, and generates performance data for reporting. This package set provides the full Icinga 2 stack for Synology NAS devices:

- **Icinga 2** — the monitoring engine (master/standalone)
- **Icinga Web 2** — the web frontend with the Director configuration module
- **Icinga 2 Agent** — a lightweight agent for distributed monitoring of remote hosts

## Package Information

| Property | Value |
|----------|-------|
| Package Name | icinga2, icingaweb2, icinga2-agent |
| Upstream | [github.com/Icinga/icinga2](https://github.com/Icinga/icinga2) |
| License | GPLv2 (Icinga 2), GPL-3.0-only (Icinga Web 2) |

## Prerequisites

- DSM 7.1 or newer (DSM 7.2 for Icinga Web 2)
- **MariaDB 10** — required for the IDO (Icinga Data Output) database and the Icinga Web 2 database
- **Web Station** with **Apache 2.4** and **PHP 8.4** (DSM 7.2) or **PHP 8.0** (DSM 7.0/7.1) — required for Icinga Web 2

## Installation

Install **Icinga 2** and **Icinga Web 2** from Package Center. The installation wizard will:

1. Prompt for the MariaDB **root** password and create the IDO database automatically
2. Prompt for an IDO database password (10+ characters with upper/lowercase, number, and special character)
3. Prompt for the Icinga Web 2 administrator username and password
4. Create the Icinga Web 2 database and a Director configuration deploy job automatically

After installation, the Icinga Web 2 frontend is available at `http://your-nas/icingaweb2/`.

## Post-Install

### Enable Ping Checks

Icinga 2 cannot run `ping` checks on DSM without extra privileges. After installing **Icinga 2**, run this command once over SSH:

```bash
fix-ping
```

This configures the `check_ping` command so host checks work correctly. It is also shown in the installation wizard.

## Icinga 2 Agent

Install **Icinga 2 Agent** on the NAS (or other hosts) you want to monitor from your master:

1. Enter the **master server** IP/hostname and port (default `5665`)
2. Optionally set the agent name (defaults to this device's hostname)
3. Enter the **Self-Service API key** from the master to auto-register and receive a signed certificate
   (found at `/volume1/@appdata/icingaweb2/etc/icingaweb2/self-service-api.key`)

> **Note:** If re-installing an agent, remove its host from Icinga Director on the master first.

## Configuration

### Icinga 2

Runtime configuration lives in `/var/packages/icinga2/var/etc/icinga2/`:

| Data | Location |
|------|----------|
| Main configuration | `/var/packages/icinga2/var/etc/icinga2/icinga2.conf` |
| API credentials (for Icinga Web 2) | `/var/packages/icinga2/var/etc/icingaweb2/api-credentials.txt` |
| IDO credentials | `/var/packages/icinga2/var/etc/icingaweb2/ido-credentials.txt` |
| Logs | `/var/packages/icinga2/var/log/icinga2/` |
| State data | `/var/packages/icinga2/var/lib/icinga2/` |

The `api-users.conf` and `constants.conf` templates pre-configure a `director-global` API user and the Icinga Web 2/Icinga Director integration.

### Icinga Web 2

Runtime configuration lives in `/var/packages/icingaweb2/var/etc/icingaweb2/`:

| Data | Location |
|------|----------|
| Configuration | `/var/packages/icingaweb2/var/etc/icingaweb2/` |
| Storage | `/var/packages/icingaweb2/var/storage/` |
| Modules | Monitoring, Director, and Incubator (enabled via symlinks) |

The monitoring module connects to the Icinga 2 API, and the Director module manages hosts, services, and agent registration declaratively.

## Ports

| Port | Package | Description |
|------|---------|-------------|
| 5665 | icinga2, icinga2-agent | Agent-to-master TLS communication |

## Service Management

- Start/Stop: Package Center or `synopkg start icinga2` / `synopkg stop icinga2`
- Icinga Web 2 is a Web Station application (not a standalone service)
- Logs: `/var/packages/icinga2/var/log/icinga2/`

## Troubleshooting

### Ping checks fail

Run `fix-ping` over SSH and restart the Icinga 2 package.

### Icinga Web 2 shows no monitoring data

Verify the IDO database feature is enabled and the IDO credentials match:
- `ls /var/packages/icinga2/var/etc/icinga2/features-enabled/` should list `ido-mysql.conf`
- Re-run the install wizard or check the Director deploy job on the *Deployments* page

### Agent cannot connect to master

- Confirm the master hostname/port (5665) are reachable and the master's firewall allows inbound connections
- Confirm the Self-Service API key is correct and the agent host was removed from Director before re-install
