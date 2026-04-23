---
title: Contributing to SynoCommunity
description: How to contribute packages, fixes, and improvements
tags:
  - contributing
  - community
---

# Contributing to SynoCommunity

SynoCommunity is a community-driven project that provides open-source packages for Synology NAS devices. We welcome contributions of all kinds!

## Ways to Contribute

### Package Development

- **New Packages** - Add support for applications not yet available
- **Package Updates** - Keep existing packages current with upstream releases
- **Bug Fixes** - Fix installation, runtime, or compatibility issues
- **Architecture Support** - Extend packages to work on more devices

### Documentation

- **Improve Guides** - Clarify instructions, add examples
- **Package Documentation** - Write or update package-specific docs
- **Translations** - Help translate wizard dialogs and descriptions

### Community Support

- **Issue Triage** - Help categorize and reproduce bug reports
- **User Support** - Answer questions in discussions and issues
- **Testing** - Test packages on different hardware and DSM versions

## Getting Started

### 1. Set Up Your Environment

Follow the [development environment setup](../developer-guide/setup/index.md) to prepare your build system.

### 2. Understand the Framework

Read through the [developer basics](../developer-guide/basics/index.md) to understand:

- Package structure and anatomy
- Build workflow and targets
- How cross-compilation works

### 3. Find Something to Work On

**Good first issues:**

- Look for issues labeled `good first issue`
- Simple version updates
- Documentation improvements

**More advanced:**

- New package requests
- Architecture-specific fixes
- Framework improvements

### 4. Follow the Development Process

See [Development Process](development-process.md) for the full workflow from fork to merge.

## Contribution Guidelines

### Code Quality

- Follow existing code style and patterns
- Keep changes focused - one package or fix per PR
- Test on real hardware when possible
- Update changelog and version numbers appropriately

### Commit Messages

Use clear, descriptive commit messages:

```
{DISPLAY_NAME}: brief description of change

Detailed explanation if needed. Reference issues with #123.
```

Use the `DISPLAY_NAME` from the package's `spk/*/Makefile` (e.g., "Transmission", "Python 3.12").

Examples:

```
Transmission: Update to v4.0.5

Python 3.12: Fix wheel building for armv5

docs: add troubleshooting section for PHP packages
```

### Pull Request Guidelines

- **Title**: `{DISPLAY_NAME}: brief description`
- **Description**: Explain what and why, not just how
- **Testing**: Describe how you tested the changes
- **Screenshots**: Include for UI changes or wizard updates

See [Pull Request Guidelines](pull-requests.md) for detailed requirements.

## Communication

### GitHub Issues

- Bug reports and feature requests
- Package-specific problems
- Build failures

### GitHub Discussions

- General questions
- Ideas and proposals
- Community announcements

### IRC/Matrix

- Real-time chat with maintainers
- Quick questions and debugging help

## Recognition

Contributors are recognized in:

- Package maintainer credits
- Repository contributor list
- Release notes for significant contributions

## Code of Conduct

We are committed to providing a welcoming and inclusive environment. Please:

- Be respectful and considerate
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Respect differing viewpoints and experiences

## Quick Links

- [Development Process](development-process.md)
- [Pull Request Guidelines](pull-requests.md)
- [Developer Guide](../developer-guide/index.md)
- [GitHub Issues](https://github.com/SynoCommunity/spksrc/issues)
- [GitHub Discussions](https://github.com/SynoCommunity/spksrc/discussions)
