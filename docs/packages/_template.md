---
title: Package Name
description: Brief description of what the package does
tags:
  - packages
  - category-tag  # e.g., media, backup, development
---

# Package Name

!!! note "Package Information"
    - **Maintainer**: @github-username
    - **Upstream**: [Project Name](https://upstream-url.com)
    - **License**: MIT/GPL/etc.

Brief description of what this package provides and its main features.

## Installation

### Prerequisites

List any requirements before installation:

- DSM 7.0 or later
- Shared folder for data storage
- (any other requirements)

### Via Package Center

1. Add SynoCommunity repository to Package Center
   - See [Installation Guide](../user-guide/installation.md)
2. Search for "Package Name"
3. Click **Install**
4. Follow the installation wizard

### Installation Wizard

The wizard will prompt for:

- **Share name**: Folder for data storage (default: `packagename`)
- (list other wizard fields)

## Configuration

### Web Interface

Access the web UI at:

```
http://your-nas-ip:PORT
```

Or via DSM:

1. Open **Main Menu**
2. Click **Package Name**

### Configuration Files

Configuration is stored in:

```
/var/packages/packagename/etc/config.conf
```

Key settings:

| Setting | Description | Default |
|---------|-------------|---------|
| `setting1` | Description | `value` |
| `setting2` | Description | `value` |

### Environment Variables

Custom environment variables can be set in:

```
/var/packages/packagename/etc/packagename.env
```

## Usage

### Basic Usage

Describe common use cases and how to accomplish them.

### Advanced Features

Document advanced functionality.

## Troubleshooting

### Package Won't Start

1. Check the logs:
   ```bash
   cat /var/packages/packagename/var/log/packagename.log
   ```
2. Verify permissions on the data folder
3. (other troubleshooting steps)

### Common Error Messages

**Error: "Description of error"**

- Cause: Explanation
- Solution: Steps to fix

### Getting Help

- Check [GitHub Issues](https://github.com/SynoCommunity/spksrc/issues)
- Upstream documentation: [Link](https://upstream-docs.com)
- Community forums: [Synology Community](https://community.synology.com)

## Architecture Support

| Architecture | DSM 6 | DSM 7 | Notes |
|-------------|-------|-------|---------|
| x64 | ✓ | ✓ | |
| aarch64 | ✓ | ✓ | |
| armv7 | ✓ | ✓ | |
| armv5 | - | - | Unsupported |
| comcerto2k | ✓ | ✓ | |

## Changelog

### Version X.Y.Z-R (YYYY-MM-DD)

- Updated to upstream version X.Y.Z
- Fixed issue with...
- Added feature...

### Version X.Y.W-R (YYYY-MM-DD)

- Previous changes...

## See Also

- Related packages (link when available)
- [Category Index](../packages/index.md)
- [Upstream Documentation](https://upstream-docs.com)
