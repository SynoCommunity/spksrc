# Archive Station

[Archive Station](https://github.com/jbdemonte/synology-archive-downloader) downloads public Internet Archive item files directly to your NAS. Each item has its own directory, with the original subdirectories preserved.

## Requirements

- DSM 7 or later and the SynoCommunity Python 3.12 package.
- A DSM administrator session to open the application.
- Internet access during installation to obtain the pinned Waitress dependency from PyPI.

The application contains only Python, JavaScript and static assets. It does not require Container Manager, Web Station or a reverse proxy. Architecture compatibility depends on the availability of Python 3.12 for your NAS.

## Installation and first download

1. Install Python 3.12 and Archive Station in Package Center.
2. Open **Archive Station** from the DSM main menu. It opens inside the DSM desktop.
3. Open **Settings** to choose your destination and simultaneous download limit.
4. Select **Add URLs** and enter one or more `https://archive.org/details/IDENTIFIER` or `https://archive.org/download/IDENTIFIER` URLs, one per line.
5. Analyze the URLs, select the files and start downloading.

The package creates an `ArchiveStation` shared folder by default. To use another shared folder, grant **Read/Write** permission to the system internal user **sc-archivestation** in DSM. Downloads remain owned by that account; other users need the shared folder's inherited permissions to access them.

## Service and data

- Package ID: `archivestation`.
- System account: `sc-archivestation`.
- Settings, SQLite queue, reports and history: `/var/packages/archivestation/var/`.
- Application log: `/var/packages/archivestation/var/archive-station.log`.
- Internal backend: `127.0.0.1:8274`. This port is not exposed on the LAN.

The DSM gateway validates the current administrator session before forwarding requests. Trusted local NAS processes can reach the loopback service; this is not an isolation boundary against other software running on the NAS.

Closing the window does not stop downloads. Pause/resume, individual file selection, scheduling, retries, SHA-1/MD5 verification, transfer history and readable text reports are available in the application. Partial files are retained separately and published under their final names after verification.

## Updates

Use **Package Center** for this edition. The upstream GitHub update checker is disabled because those downloads have a different package identity and include a standalone Python runtime.

Normal updates retain the package data directory and downloaded files. The service gets up to 60 seconds to stop before a forced stop. On restart, the engine recovers interrupted transfers. Back up the data directory with the service stopped before migration or manual maintenance; include the SQLite WAL files if present.

## Existing standalone GitHub installations

The standalone package is named `ArchiveStation` and uses the `ArchiveStation` account. It is **not** an in-place upgrade to this `archivestation` package. Package Center is instructed to reject installing both together: they share the same DSM application identifier and backend port.

Do not uninstall a working standalone installation merely to test this recipe. A migration requires a stopped-service backup of `/var/packages/ArchiveStation/var/`, installation of the new package, restoration into its own data directory with the new account's ownership, and granting `sc-archivestation` access to every existing destination. Keep both services stopped throughout the state transfer. Downloaded content should remain at its existing paths.

There is no automatic migration in this initial recipe. Keep the standalone edition until a migration has been validated for your installation. Never point two independent queues at the same destination files.

## Build and validation

The recipe uses a checksum-verified upstream 1.0.0 source release and a pinned pure-Python dependency. From the spksrc build environment:

```bash
make -C spk/archivestation arch-x64-7.2
make -C spk/archivestation arch-noarch-7.1
```

Before publication, test a fresh installation and reinstall the same SPK as an upgrade on a test NAS. Check DSM session authentication, folder permissions, a verified download, pause/resume and recovery across service restart and upgrade. Retain the original data and downloads during these checks.

See the [upstream usage guide](https://github.com/jbdemonte/synology-archive-downloader/blob/main/docs/USAGE.md) for the full feature reference.
