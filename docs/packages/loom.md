# Loom

[Loom](https://loom.deroock.co.za) is a unified, self-hosted media automation server — a single-binary replacement for the Radarr/Sonarr/Prowlarr/Overseerr stack. It searches indexers, drives your download clients, imports and organizes movies and TV, and ships a built-in web UI and request portal.

!!! note "Package Information"
    - **Maintainer**: @Ebenderooock
    - **Upstream**: [Loom](https://github.com/Ebenderooock/loom)
    - **License**: AGPL-3.0

## Web Interface

Loom serves its web UI and API over plain HTTP on port **1925**:

```
http://<your-nas-ip>:1925
```

There is no separate admin application — the web UI is the whole interface. For TLS, put Loom behind the DSM **Application Portal** reverse proxy rather than exposing the port directly.

## Data and Configuration

Loom is a single static binary and keeps all of its mutable state — the `loom.json` config, the SQLite database, caches and logs — under the package's persistent var directory, which DSM preserves across package upgrades:

```
/var/packages/loom/var/
```

No manual configuration file editing is required; everything is managed from the web UI on first run.

## Download Clients

The built-in torrent engine is **disabled in this package**. In Loom 0.2.x that engine runs as an external [Rain](https://github.com/cenkalti/rain) sidecar daemon reached over RPC — a deployment model that suits container/Kubernetes setups but not a self-contained Synology package, so this build ships with it turned off (it is hidden in the UI and rejected by the API).

Instead, point Loom at a standalone download client. Any of these SynoCommunity packages work well alongside Loom:

- [Transmission](transmission.md)
- [Deluge](deluge.md)
- [Aria2](aria2.md)
- qBittorrent / SABnzbd / NZBGet (or any remote instance reachable from your NAS)

Add the client under **Settings → Download Clients** in the Loom web UI using the client's host, port and credentials.

## Getting Help

- [Loom documentation](https://loom.deroock.co.za)
- [Upstream issues](https://github.com/Ebenderooock/loom/issues)
- [SynoCommunity issues](https://github.com/SynoCommunity/spksrc/issues)
