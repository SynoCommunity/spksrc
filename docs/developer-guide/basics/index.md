# Development Basics

This section covers the fundamentals of building and creating packages with spksrc.

## Overview

spksrc uses a hierarchical build system based on GNU Make. Understanding the key concepts will help you work effectively with the framework.

## Key Concepts

### Package Types

spksrc has two main package categories:

- **cross/**: Software compiled for the target NAS architecture
- **spk/**: Final SPK packages that install on Synology devices

### Build Flow

```
cross/dependency → cross/package → spk/package → packages/*.spk
```

1. **Dependencies** are built first (other cross/ packages)
2. **Source code** is downloaded and extracted
3. **Cross-compilation** produces binaries for the target architecture
4. **SPK packaging** creates the installable package

### Architectures

Packages are built for specific CPU architecture + DSM version combinations:

| Architecture | Description |
|--------------|-------------|
| `x64-7.2` | Intel 64-bit, DSM 7.2 |
| `aarch64-7.2` | ARM 64-bit, DSM 7.2 |
| `armv8-7.2` | ARM 64-bit (Realtek), DSM 7.2 |
| `x64-6.2` | Intel 64-bit, DSM 6.2 |

## In This Section

- **[Your First Package](first-package.md)** - Build an existing package to verify your setup
- **[Package Anatomy](package-anatomy.md)** - Understand the structure of a package
- **[Build Workflow](build-workflow.md)** - Learn build commands and targets
