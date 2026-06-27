# Developer Guide

This guide covers everything you need to know to build and contribute packages to SynoCommunity.

## Overview

spksrc is a cross-compilation framework that builds software for Synology NAS devices. It handles:

- Downloading and extracting source code
- Cross-compiling for multiple CPU architectures
- Packaging as SPK files installable via Package Center
- Managing dependencies between packages

## Getting Started

### 1. Set Up Your Environment

Choose your development environment:

- **[Docker](setup/docker.md)** - Recommended for most users. Works on Linux and macOS.
- **[Virtual Machine](setup/vm.md)** - Full Debian environment. Good for heavy development.
- **[LXC Container](setup/lxc.md)** - Lightweight alternative to VMs on Linux.

### 2. Learn the Basics

Once your environment is ready:

- **[Your First Package](basics/first-package.md)** - Build an existing package
- **[Package Anatomy](basics/package-anatomy.md)** - Understand package structure
- **[Build Workflow](basics/build-workflow.md)** - Learn how builds work

### 3. Create or Improve Packages

Deep-dive into package development:

- **[Packaging Guide](packaging/index.md)** - Makefiles, PLIST, services, and more
- **[Package Types](package-types/index.md)** - Python, Go, Rust, web applications
- **[Advanced Topics](advanced/index.md)** - Cross-compilation, debugging

### 4. Contribute

Share your work:

- **[Publishing](publishing/index.md)** - GitHub Actions, releases
- **[Contributing Guide](../contributing/index.md)** - Pull request guidelines

## Quick Reference

| Need to... | See... |
|------------|--------|
| Build an existing package | [Build Workflow](basics/build-workflow.md) |
| Create a new package | [Your First Package](basics/first-package.md) |
| Add a service/daemon | [Service Scripts](packaging/service-scripts.md) |
| Package a Python app | [Python Packages](package-types/python.md) |
| Debug build issues | [Debugging](advanced/debugging.md) |
| Look up a Makefile variable | [Makefile Variables](packaging/makefile-variables.md) |

## Community Resources

- **Discord**: [Join our server](https://discord.gg/nnN9fgE7EF) for real-time help
- **GitHub**: [SynoCommunity/spksrc](https://github.com/SynoCommunity/spksrc)
- **Wiki**: [Legacy documentation](https://github.com/SynoCommunity/spksrc/wiki) (being migrated here)

## External Resources

- **[Synology Package Developer Guide](https://help.synology.com/developer-guide/)** - Official documentation from Synology
- **[Synology Toolkit](https://github.com/SynologyOpenSource/pkgscripts-ng)** - Official build scripts
- **[Synology GPL Source](https://sourceforge.net/projects/dsgpl/files/)** - Toolchains and kernel source
