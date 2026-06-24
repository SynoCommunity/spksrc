# Manual Publishing

This guide covers how to manually build and publish packages to SynoCommunity without using GitHub Actions CI.

## Prerequisites

### API Key Setup

1. Get your API key from [synocommunity.com/profile](https://synocommunity.com/profile)
2. Create or update `local.mk` in the spksrc root:

```makefile
PUBLISH_URL = https://api.synocommunity.com
PUBLISH_API_KEY = <your-key>
DISTRIBUTOR = SynoCommunity
DISTRIBUTOR_URL = https://synocommunity.com/
REPORT_URL = https://github.com/SynoCommunity/spksrc/issues
DEFAULT_TC = 7.1 7.2
```

Or generate automatically:

```bash
make setup-synocommunity
```

## Building for All Architectures

Build all supported architectures in parallel:

```bash
make -j$(nproc) all-supported
```

Or build specific architectures:

```bash
make -j$(nproc) arch-x64-7.1 arch-armv7-7.1 arch-aarch64-7.1
```

### Generic Architectures

These architectures generate a single package for multiple CPU models:

| Generic Arch | Covers |
|--------------|--------|
| x64 | All Intel/AMD 64-bit |
| armv7 | 32-bit ARM Cortex |
| aarch64 | 64-bit ARM |

## Publishing

Publish packages (one at a time, not parallel):

```bash
make publish-all-supported
```

Or specific architectures:

```bash
make publish-arch-x64-7.1 publish-arch-armv7-7.1 publish-arch-aarch64-7.1
```

!!! warning
    Do not parallelize publishing. The spkrepo server cannot handle concurrent uploads.

## Dynamic Library Linking

Some packages share dependencies through dynamic linking:

```bash
cd spk/chromaprint
for arch in x64 evansport 88f6281 armv7 aarch64 hi3535; do
    make publish ARCH=$arch TCVERSION=7.1
done
```

Packages using this pattern: tvheadend, chromaprint, comskip

## SRM Packages

SRM (Synology Router Manager) has no Package Center custom repository support.

Users must:

1. Download packages manually from [synocommunity.com/packages](https://synocommunity.com/packages)
2. Install via manual upload

Build SRM packages:

```bash
make publish ARCH=armv7 TCVERSION=1.2
```

## After Publishing

See [Repository Activation](repository-activation.md) for steps to activate your published packages.

## See Also

- [GitHub Actions CI/CD](github-actions.md) - Automated builds and publishing
- [Repository Activation](repository-activation.md) - Activating published packages
- [Update Policy](update-policy.md) - Supported versions and testing checklist
