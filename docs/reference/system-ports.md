# Ports

This page documents port allocations for Synology system services.

For SynoCommunity package ports, see [Package Ports](package-ports.md).

## Overview

When creating packages, choose ports that don't conflict with:

- Synology system services
- Other SynoCommunity packages
- Common applications

## Synology System Ports

### DSM Web Interface

| Port | Protocol | Service |
|------|----------|--------|
| 5000 | HTTP | DSM web interface |
| 5001 | HTTPS | DSM web interface (SSL) |
| 5005 | HTTP | WebStation HTTP |
| 5006 | HTTPS | WebStation HTTPS |

### File Services

| Port | Protocol | Service |
|------|----------|--------|
| 137-139 | UDP/TCP | NetBIOS/SMB |
| 445 | TCP | SMB/CIFS |
| 548 | TCP | AFP (Apple Filing Protocol) |
| 2049 | TCP/UDP | NFS |
| 111 | TCP/UDP | portmapper (NFS) |
| 20-21 | TCP | FTP |
| 22 | TCP | SSH/SFTP |
| 873 | TCP | rsync |

### Web Services

| Port | Protocol | Service |
|------|----------|--------|
| 80 | HTTP | Web Station |
| 443 | HTTPS | Web Station (SSL) |
| 8080 | HTTP | Alternate web |
| 8443 | HTTPS | Alternate web (SSL) |

### Media Services

| Port | Protocol | Service |
|------|----------|--------|
| 1900 | UDP | UPnP/DLNA |
| 50001 | TCP | DLNA |
| 50002 | TCP | DLNA |
| 8200 | TCP | Photo Station |
| 9997 | TCP | iTunes Server |
| 32400 | TCP | Plex (common) |

### Database & Applications

| Port | Protocol | Service |
|------|----------|--------|
| 3306 | TCP | MariaDB/MySQL |
| 5432 | TCP | PostgreSQL |
| 6690 | TCP | Synology Drive |
| 9900 | TCP | DSM finder |

### Backup & Sync

| Port | Protocol | Service |
|------|----------|--------|
| 6281 | TCP | Synology Assistant |
| 5566 | TCP | Active Backup |
| 873 | TCP | rsync |

## External References

- [IANA Service Name and Transport Protocol Port Number Registry](https://www.iana.org/assignments/service-names-port-numbers/)
- [Synology Knowledge Base - What network ports are used by Synology services?](https://kb.synology.com/en-global/DSM/tutorial/What_network_ports_are_used_by_Synology_services)
