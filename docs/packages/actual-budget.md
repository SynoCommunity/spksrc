---
title: Actual Budget
description: Local-first personal finance, budgeting and expense tracking
tags:
  - finance
  - budgeting
  - web
---

# Actual Budget

Actual Budget is a local-first personal finance app for budgeting and expense tracking. This package runs the sync server, which stores your encrypted budget data and serves the web app.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | actual-budget |
| Upstream | [github.com/actualbudget/actual](https://github.com/actualbudget/actual) |
| License | MIT |
| Default Port | 8007 (upstream default 5006 is reserved by WebStation HTTPS) |

## Installation

1. Install Actual Budget from Package Center
2. [Set up HTTPS access](#https-setup) — required, browsers refuse to run the app over plain HTTP
3. Open the app at your `https://` address and create your budget

## HTTPS Setup

!!! warning
    Actual Budget encrypts your data end-to-end in the browser using SharedArrayBuffer, which browsers only enable in secure contexts (HTTPS, or localhost for local testing). Over plain `http://<nas-ip>:8007` the app shows a Fatal Error page — this is expected, not a broken install. Set up a reverse proxy with a certificate before using the app. No extra proxy headers are needed: the server already sends the required `Cross-Origin-Opener-Policy` and `Cross-Origin-Embedder-Policy` headers.

### Step 1: Create a Certificate (if needed)

- Go to **Control Panel** > **Security** > **Certificate**
- Add a certificate via Let's Encrypt or import your own

### Step 2: Create Reverse Proxy Entry

Navigate to the Reverse Proxy settings:

- **DSM 7**: **Control Panel** > **Login Portal** > **Advanced** > **Reverse Proxy**
- **DSM 6**: **Control Panel** > **Application Portal** > **Reverse Proxy**

Click **Create** and configure as follows:

| Field | Value |
|-------|-------|
| **Description** | Actual Budget |
| **Source Protocol** | HTTPS |
| **Source Hostname** | Your domain |
| **Source Port** | 443 (or custom) |
| **Destination Protocol** | HTTP |
| **Destination Hostname** | localhost |
| **Destination Port** | 8007 |

### Step 3: Assign Certificate

- Go to **Control Panel** > **Security** > **Certificate**
- Click **Settings** (DSM 7) or **Configure** (DSM 6)
- Assign your certificate to the Actual Budget reverse proxy entry

## Configuration

### Data Location

- Budget data: `/var/packages/actual-budget/var/data/`

### Environment Variables

The service is configured via environment variables (see `src/service-setup.sh` in the [spksrc repository](https://github.com/SynoCommunity/spksrc)):

- `PORT` — listen port (defaults to the configured service port, 8007)
- `ACTUAL_DATA_DIR` — data directory (`/var/packages/actual-budget/var/data`)
- `NODE_ENV=production`

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 8007 | TCP | Web interface and sync API |

## Backup

Back up this directory regularly — it contains all budget files:

- `/var/packages/actual-budget/var/data/` — `server-files/` (budgets) and `user-files/`

## Troubleshooting

### Fatal Error: "Actual requires access to SharedArrayBuffer"

You opened the app over plain HTTP. Switch to your HTTPS address — see [HTTPS Setup](#https-setup). Do not use the unsupported fallback mode for real budgets.

## External Resources

- [Actual Budget documentation](https://actualbudget.org/docs)
- [SharedArrayBuffer troubleshooting](https://actualbudget.org/docs/troubleshooting/shared-array-buffer)
- [Upstream repository](https://github.com/actualbudget/actual)
