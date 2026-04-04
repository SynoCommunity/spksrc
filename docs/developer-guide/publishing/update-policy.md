# Update Policy and Process

This guide covers the SynoCommunity package update policy, including supported DSM versions and testing requirements.

## Supported DSM Versions

| Version | Status | Notes |
|---------|--------|-------|
| DSM 7.1 | **Active** | Primary target |
| DSM 7.2 | **Active** | Supported (opt-in) |
| DSM 6.2.4+ | **Active** | Supported |
| DSM 6.0-6.2.3 | Limited | May work, not tested |
| DSM 5.2 | Legacy | On request only |
| SRM 1.x | Limited | Manual install only |

!!! note
    DSM 5.2 packages are no longer built automatically. Older toolchains may not support recent upstream versions.

## Testing Checklist

Before publishing, verify:

### Package Features

- [ ] Description translations are correct
- [ ] Wizard pages function correctly (install and upgrade)
- [ ] Wizard translations are complete

### Service Operation

- [ ] Service starts from Package Center
- [ ] Service stops from Package Center
- [ ] Log files exist in `/var/packages/{package}/var/`
- [ ] DSM shortcut opens the interface

### Command Line Tools

- [ ] Binaries appear in PATH (via `/usr/local/bin` links)
- [ ] Version commands work (`--version`, `-v`)
- [ ] Help commands work (`--help`, `-h`)

### Uninstall

- [ ] Package removes cleanly from `/var/packages/{package}/`

## See Also

- [GitHub Actions CI/CD](github-actions.md) - Automated builds and publishing
- [Manual Publishing](manual-publishing.md) - Building and publishing without CI
- [Repository Activation](repository-activation.md) - Activating published packages
