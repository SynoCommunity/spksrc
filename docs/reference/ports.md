# Ports

This page documents port allocations for Synology system services and SynoCommunity packages.

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

## SynoCommunity Package Ports

The following ports are used by SynoCommunity packages:

### Download Managers

| Port | Package | Description |
|------|---------|-------------|
| 8384 | Syncthing | Web interface |
| 22000 | Syncthing | Sync protocol |
| 9091 | Transmission | Web interface |
| 51413 | Transmission | BitTorrent |
| 8112 | Deluge | Web interface |
| 58846 | Deluge | Daemon |
| 8080 | SABnzbd | Web interface |
| 9090 | SABnzbd | HTTPS interface |

### Media Management

| Port | Package | Description |
|------|---------|-------------|
| 8096 | Jellyfin | Web interface |
| 8920 | Jellyfin | HTTPS interface |
| 7359 | Jellyfin | Discovery |
| 4533 | Navidrome | Web interface |
| 8989 | Sonarr | Web interface |
| 7878 | Radarr | Web interface |
| 8686 | Lidarr | Web interface |
| 6767 | Bazarr | Web interface |
| 9696 | Prowlarr | Web interface |
| 8787 | Readarr | Web interface |

### Home Automation

| Port | Package | Description |
|------|---------|-------------|
| 8123 | Home Assistant | Web interface |

### Development & Tools

| Port | Package | Description |
|------|---------|-------------|
| 9000 | Portainer | Web interface |
| 5050 | pgAdmin | Web interface |
| 3000 | Grafana | Web interface |
| 8888 | Jupyter | Notebook interface |

### Monitoring

| Port | Package | Description |
|------|---------|-------------|
| 9100 | node_exporter | Metrics |
| 9090 | Prometheus | Web interface |

### Communication

| Port | Package | Description |
|------|---------|-------------|
| 5222 | ejabberd | XMPP client |
| 5269 | ejabberd | XMPP server |
| 5280 | ejabberd | HTTP admin |

## Choosing Ports for New Packages

### Guidelines

1. **Avoid system ports** - Don't use ports below 1024 without good reason
2. **Check conflicts** - Search this page and Synology docs
3. **Use upstream defaults** - If the software has a common port, use it
4. **Document the port** - Add to `SERVICE_PORT` in Makefile
5. **Consider firewall** - Use port-config resource files

### Recommended Ranges

| Range | Use Case |
|-------|----------|
| 1024-49151 | Registered ports (prefer upstream defaults) |
| 49152-65535 | Dynamic/private (use for internal services) |

### Registering New Ports

When adding a new package with a dedicated port:

1. Check this documentation for conflicts
2. Use the upstream project's default port if possible
3. Document the port in your package's Makefile:

```makefile
SERVICE_PORT = 8080
SERVICE_PORT_TITLE = Web Interface
```

4. Consider opening a PR to update this documentation

## External References

- [IANA Service Name and Transport Protocol Port Number Registry](https://www.iana.org/assignments/service-names-port-numbers/)
- [Synology Knowledge Base - What network ports are used by Synology services?](https://kb.synology.com/en-global/DSM/tutorial/What_network_ports_are_used_by_Synology_services)
