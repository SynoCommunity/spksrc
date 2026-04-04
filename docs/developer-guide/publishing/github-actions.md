---
title: GitHub Actions CI/CD
description: Automated building and publishing with GitHub Actions
tags:
  - publishing
  - ci-cd
  - github-actions
---

# GitHub Actions CI/CD

SynoCommunity uses GitHub Actions for automated building, testing, and publishing of packages.

## Build Pipeline Overview

### Pull Request Builds

When you submit a PR, the CI system automatically:

1. **Detects Changed Packages** - Identifies which packages need building
2. **Builds for All Architectures** - Creates SPK files for supported platforms
3. **Runs Basic Validation** - Checks package structure and metadata
4. **Uploads Artifacts** - Makes build outputs available for testing

### Package Detection

The CI determines which packages to build by:

- Checking files changed in the PR
- Following dependency chains (if `cross/libfoo` changes, all packages using it rebuild)
- Respecting `UNSUPPORTED_ARCHS` settings

## Workflow Files

### Main Build Workflow

Located at `.github/workflows/build.yml`. By default, packages build for DSM 7.1 and DSM 6.2. DSM 7.2 builds are opt-in and require setting `TCVERSION=7.2` as a minimum in the package Makefile.

### Build Matrix

Packages are built across multiple architectures:

| Architecture | Typical Hardware |
|-------------|------------------|
| x64-7.1 | Modern Intel/AMD |
| aarch64-7.1 | ARM64 (DS923+, etc.) |
| armv7-7.1 | Older ARM (DS218, etc.) |
| x64-6.2 | Intel/AMD (DSM 6) |

## Build Actions

### `.github/actions/build.sh`

The main build script handles:

```bash
# Package-specific build
make -C spk/${PKG_NAME} ARCH=${ARCH} TCVERSION=${TCVERSION}

# Dependency-based full build
make -C spk/${PKG_NAME} dependency-flat | xargs make
```

### Cache Management

To speed up builds, the CI caches:

- **Toolchains** - Cross-compilation toolchains (large, shared)
- **Distrib** - Downloaded source tarballs
- **Wheels** - Pre-built Python wheels

Cache keys include architecture and version to prevent conflicts.

## Triggering Builds

### Automatic Triggers

- **Push to master** - Builds and publishes release packages
- **Pull requests** - Builds for validation (no publish)
- **Workflow dispatch** - Manual trigger with custom parameters

### Manual Builds

You can manually trigger builds from the Actions tab:

1. Go to **Actions** > **Build**
2. Click **Run workflow**
3. Select branch and optionally specify packages

## Artifact Retrieval

### Download Build Artifacts

After a successful PR build:

1. Go to the PR's **Checks** tab
2. Click on the build workflow
3. Scroll to **Artifacts** section
4. Download the SPK files for your architecture

### Artifact Naming

SPK artifacts follow the pattern:

```
{package}_{arch}-{tcversion}_{pkgversion}-{spkrevision}.spk

# Examples
transmission_x64-7.2_4.0.5-11.spk
python312_aarch64-7.2_3.12.4-6.spk
```

## Publishing Process

### Automatic Publishing

When PRs are merged to master:

1. Packages build against release configurations
2. SPK files are uploaded to the package repository
3. Repository index regenerates
4. Users see updates in Package Center

After automatic publishing, packages need to be activated. See [Repository Activation](repository-activation.md) for details.

For manual publishing without CI, see [Manual Publishing](manual-publishing.md).

## Debugging Build Failures

### Common CI Issues

**Architecture-specific failures:**

- Check `UNSUPPORTED_ARCHS` in package Makefile
- Review architecture-specific patches
- Examine cross-compilation flags

**Cache-related failures:**

- Stale caches can cause issues
- Request cache clear from maintainers if needed
- Check for `.done` marker file issues

**Timeout failures:**

- Large packages may need workflow timeout increase
- Consider splitting into smaller components

### Viewing Full Logs

1. Click on failed job
2. Expand the failing step
3. Click "View raw logs" for complete output
4. Search for `error:` or `Error:` patterns

## Best Practices

### Before Submitting PRs

1. **Test locally** on at least one architecture
2. **Check dependencies** - ensure all are available
3. **Verify PLIST** - all files properly listed
4. **Test install/uninstall** on real hardware if possible

### PR Hygiene

- Keep changes focused - one package per PR
- Update changelog and version appropriately
- Respond to CI failures promptly
- Don't force-push after review starts

### Monitoring Builds

- Watch for dependency chain failures
- Monitor build times for regressions
- Report infrastructure issues to maintainers

## See Also

- [Publishing Overview](index.md)
- [Package Server Setup](package-server.md)
- [Repository Activation](repository-activation.md)
- [Manual Publishing](manual-publishing.md)
- [Build Workflow](../basics/build-workflow.md)
