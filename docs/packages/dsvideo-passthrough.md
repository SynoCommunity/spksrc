---
title: DS Video HEVC Passthrough
description: Proxy that lets DS Video play HEVC files via raw passthrough
tags:
  - packages
  - media
---

# DS Video HEVC Passthrough

!!! note "Package Information"
    - **Maintainer**: [@holg](https://github.com/holg)
    - **Upstream**: [ds-video-hevc](https://github.com/holg/ds-video-hevc)
    - **License**: MIT
    - **Default port**: 5080

`dsvideo-passthrough` is a small HTTP proxy in front of Synology **Video Station**. It lets the **DS Video** app (Apple TV and other clients) play HEVC files untouched instead of forcing a transcode the NAS cannot handle.

DS Video asks Video Station to open a stream with `hls_remux`. On NAS CPUs without an HEVC profile, Video Station refuses those sources (error 1211) and DS Video falls back to a full transcode. The proxy retries the same open in `raw` mode and rewrites the following stream/close calls so the client gets the original file.

## Prerequisites

- DSM 7.0 or later
- **Video Station** installed
- A client that can decode HEVC natively (for example Apple TV)

## Installation

1. Add the SynoCommunity repository to Package Center (see the [Installation Guide](../user-guide/installation.md)).
2. Search for **DS Video HEVC Passthrough** and install it.
3. In the wizard, keep the defaults unless you need a different port:
   - **Listen port**: `5080`
   - **Video Station URL**: `http://127.0.0.1:5000`
4. In DS Video, set the server address to `<your-nas>:5080`.

Settings are stored in `/var/packages/dsvideo-passthrough/var/config` (`PORT=` and `UPSTREAM=`) and survive upgrades. The package firewall rule advertises the default port 5080; if you change the listen port, open that port yourself.

## Limitations

- Only plain `http://` upstreams are supported. Keep the proxy on the LAN, or put it behind a TLS-terminating reverse proxy.
- Raw passthrough sends the original file. There is no subtitle burn-in or audio transcoding in this mode.

## Logs

The service log is `/var/packages/dsvideo-passthrough/var/dsvideo-passthrough.log`. It is rotated when it grows past 5 MB.

## See Also

- [Upstream README](https://github.com/holg/ds-video-hevc)
- [Package Catalog](index.md)
