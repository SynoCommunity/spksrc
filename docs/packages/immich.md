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
