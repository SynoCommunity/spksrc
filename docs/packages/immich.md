# Immich

[Immich](https://immich.app) is a self-hosted photo and video backup solution, with built-in AI/ML smart search, facial recognition, and map features.

!!! note "Package Information"
    - **Upstream**: [Immich](https://github.com/immich-app/immich)
    - **License**: AGPL-3.0
    - **Default Port**: 2283

## Prerequisites

- DSM 7.2 or later (64-bit only)
- SynoCommunity repository added to Package Center (see [Installation Guide](../user-guide/installation.md))

When you install Immich, Package Center will automatically prompt you to install required dependencies (PostgreSQL, Redis, Node.js_v22, ffmpeg8, Perl, Python 3.14) if they aren't already present.

## Installation

### Step 1 — Install PostgreSQL

Install the PostgreSQL package from SynoCommunity when prompted. During installation, create an administrator account and remember the credentials. PostgreSQL runs on port **5433** (the SynoCommunity package uses this port to avoid conflict with Synology's built-in PostgreSQL on 5432).

All required extensions (`unaccent`, `cube`, `earthdistance`, `pg_trgm`, `uuid-ossp`, `vector`) are included automatically.

### Step 2 — Install Immich

Install the Immich package from SynoCommunity. The installation wizard will guide you through three screens:

**Database Configuration**
- Enter the PostgreSQL admin credentials from Step 1
- The installer creates a dedicated `immich` database user and database

**Shared Folder**
- Select or create a DSM shared folder for media storage (photos, videos, thumbnails)

**Machine Learning (Optional)**
- If enabled, approximately 300 MB of Python ML dependencies are installed
- Provides smart search, facial recognition, and OCR

### Step 3 — Access Immich

Once installed, access the web interface at:

```
http://<your-nas-ip>:2283
```

Follow the on-screen prompts to create your admin account.

## Updating

Updates are handled through DSM's Package Center. The database and media files are preserved during updates.

## Uninstalling

The uninstall wizard offers the option to export your Immich database in a format compatible with the upstream backup mechanism.

## Getting Help

For package-related issues, please open a ticket with SynoCommunity first. The maintainers can escalate to upstream if the issue originates outside the package.

- [SynoCommunity issues](https://github.com/SynoCommunity/spksrc/issues)
- [Upstream issues](https://github.com/immich-app/immich/issues)
- [Immich documentation](https://immich.app/docs)

## Advanced: Changing the Media Location

If you need to move Immich's media storage to a new location (e.g., renaming a DSM shared folder, migrating to a new volume), the following steps are required to keep everything in sync.

### Before You Start

- Stop the Immich package in Package Center (or `sudo synopkg stop immich`)
- Ensure the new location exists and is accessible

### Step 1 — Update Database Paths

Run the `immich-admin` CLI to update stored file paths in the database:

```bash
sudo /var/packages/immich/target/bin/immich-admin change-media-location
```

You will be prompted for:

- **Previous value** — the old media location (e.g., `/volume1/immich-media`)
- **New value** — the new media location (e.g., `/volume1/Photos`)

The tool updates paths in the `asset`, `asset_file`, `person`, and `user` tables.

### Step 2 — Update System Metadata

The CLI does not update the `system_metadata` table, so this must be done manually via `psql`. You will be prompted for the Immich database password (set during installation):

```bash
/usr/local/bin/psql -h localhost -p 5433 -U immich -d immich -c \
  "UPDATE system_metadata SET value = '{\"location\":\"/volume1/Photos\"}' WHERE key = 'MediaLocation';"
```

Verify the change:

```bash
/usr/local/bin/psql -h localhost -p 5433 -U immich -d immich -c \
  "SELECT * FROM system_metadata WHERE key = 'MediaLocation';"
```

Expected output:

```
      key      |              value              
---------------+---------------------------------
 MediaLocation | {"location": "/volume1/Photos"}
(1 row)
```

!!! tip "Alternative: interactive psql"
    If you prefer an interactive session: `/usr/local/bin/psql -h localhost -p 5433 -U immich -d immich` then paste the SQL without the shell escaping:
    ```sql
    UPDATE system_metadata SET value = '{"location":"/volume1/Photos"}' WHERE key = 'MediaLocation';
    ```

### Step 3 — Update Immich Configuration

Edit the runtime config and change `IMMICH_MEDIA_LOCATION` to the new path:

```bash
sudo vi /var/packages/immich/etc/immich.conf
```

For example, change:

```
IMMICH_MEDIA_LOCATION=/volume1/immich-media
```

to:

```
IMMICH_MEDIA_LOCATION=/volume1/Photos
```

### Step 4 — Update DSM Share (if applicable)

If you renamed the DSM shared folder, update the installer variables and share symlink:

```bash
sudo vi /var/packages/immich/etc/installer-variables
```

Update `SHARE_PATH` and `SHARE_NAME` to match the new location and name. For example:

```
SHARE_PATH=/volume1/Photos
SHARE_NAME=Photos
```

Then update the symlink in the shares directory:

```bash
cd /var/packages/immich/shares
sudo ln -sf /volume1/Photos Photos
sudo rm -f immich-media
```

### Step 5 — Restart

Start the Immich package in Package Center (or `sudo synopkg start immich`). The server should detect that the media location is consistent and start normally.
