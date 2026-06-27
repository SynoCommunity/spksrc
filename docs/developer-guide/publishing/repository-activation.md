# Repository Activation

After publishing packages to the SynoCommunity repository, you need to activate them before they become available to users.

## Prerequisites

- Maintainer access to the SynoCommunity repository
- Successfully built and uploaded packages (via [GitHub Actions](github-actions.md) or manual publishing)

## Activation Process

### 1. Check Your Builds

1. Log in at [synocommunity.com/admin/](https://synocommunity.com/admin/)
2. Navigate to [synocommunity.com/admin/build/](https://synocommunity.com/admin/build/)
3. Find your recently uploaded builds

### 2. Test Activation

Before making packages publicly available:

1. Activate your test build from the admin panel
2. Install/upgrade from DSM Package Center to verify functionality
3. Test core features work as expected

### 3. Version Activation

If testing is successful:

1. Navigate to [synocommunity.com/admin/version/](https://synocommunity.com/admin/version/)
2. Activate the Version to make it publicly available
3. Users will see the update in Package Center

## Package Signing

!!! note "DSM Version Differences"
    - **DSM 6.x**: Package signing ensures that packages are recognized as coming from a trusted publisher. Users must configure their trust level settings to allow installation of packages signed by Synology Inc. and trusted publishers.
    - **DSM 7+**: Only Synology-signed packages are trusted. All community packages will always show a third-party warning during installation, regardless of signing.

## See Also

- [GitHub Actions CI/CD](github-actions.md) - Automated builds and publishing
- [Manual Publishing](manual-publishing.md) - Publishing without CI
- [Update Policy](update-policy.md) - Supported versions and testing checklist
