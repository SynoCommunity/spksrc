---
title: Beets
description: Music library management system
tags:
  - media
  - music
  - library
---

# Beets

Beets is the media library management system for obsessive music geeks. It catalogs your collection, automatically improving its metadata.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | beets |
| Upstream | [beets.io](https://beets.io/) |
| License | MIT |

## Features

- Automatic metadata correction via MusicBrainz
- Album art fetching
- Duplicate detection
- Format conversion
- Plugin system
- Web interface (optional)

## Installation

1. Install Beets from Package Center
2. Configure via SSH

## Configuration

### Configuration File

Edit `/var/packages/beets/var/config.yaml`:

```yaml
directory: /volume1/music
library: /var/packages/beets/var/library.db

import:
    move: yes
    copy: no
    write: yes

paths:
    default: $albumartist/$album/$track $title
    singleton: Non-Album/$artist/$title
    comp: Compilations/$album/$track $title
```

### Plugins

Enable plugins in config:

```yaml
plugins:
    - fetchart
    - embedart
    - lastgenre
    - web
    - duplicates
```

## Usage

### Import Music

```bash
# Import with prompts
/var/packages/beets/target/env/bin/beet import /path/to/music

# Automatic import
/var/packages/beets/target/env/bin/beet import -A /path/to/music

# Import as singles (non-album tracks)
/var/packages/beets/target/env/bin/beet import -s /path/to/music
```

### Query Library

```bash
# List all albums
beet ls -a

# Search by artist
beet ls artist:Beatles

# Search by year
beet ls year:2020
```

### Update Metadata

```bash
# Update tags from MusicBrainz
beet update

# Fetch missing album art
beet fetchart
```

### Web Interface

Enable the web plugin and access at port 8337:

```yaml
web:
    host: 0.0.0.0
    port: 8337
```

## Integration

Beets works well with:
- [Navidrome](navidrome.md) - Music streaming
- Lidarr - Music management

## Troubleshooting

### Import Hangs

Try limiting concurrent tasks:
```yaml
import:
    threads: 1
```

### Wrong Matches

Use interactive mode and select correct release:
```bash
beet import /path/to/album
```
