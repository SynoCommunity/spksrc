# AI Agent Instructions for spksrc

This file provides guidance for AI coding assistants working with the spksrc repository.

## Overview

spksrc is a cross-compilation framework for building Synology NAS packages (SPK files). The codebase uses GNU Make extensively with custom Makefile includes.

## Key Principles

1. **Don't push to GitHub without explicit user approval** - Always ask before pushing commits
2. **Test builds before committing** - Run `make arch-x64-7.2` to verify changes compile
3. **Preserve existing patterns** - Follow conventions from similar packages in the repo
4. **Patches must apply cleanly** - No fuzz or offset warnings

## Directory Conventions

- `cross/` - Libraries and applications cross-compiled for target architecture
- `spk/` - Final SPK package definitions that users install
- `native/` - Tools built for the host system (used during cross-compilation)
- `mk/` - Framework Makefiles (avoid modifying unless necessary)
- `toolchain/` - Synology toolchain definitions (rarely modified)

## Common Operations

### Building a Package
```bash
cd spk/packagename
make arch-x64-7.2  # Build for specific architecture
make clean         # Clean build artifacts
```

### Updating Package Version
1. Edit `PKG_VERS` in `cross/packagename/Makefile`
2. Run `make digests` to update checksums
3. Edit `SPK_VERS` in `spk/packagename/Makefile`, increment `SPK_REV`
4. Update `CHANGELOG`
5. Test with `make arch-x64-7.2`

### Creating Patches
- Use unified diff format (`diff -u`)
- Name sequentially: `001-description.patch`, `002-another.patch`
- Place arch-specific patches in `patches/archname/` subdirectory
- Patches apply with `-p0` (no directory prefix stripping)

## Versioning Rules

- `SPK_REV` starts at 1, increments for packaging changes
- Never reset `SPK_REV` - always increment, even when `SPK_VERS` changes
- Never decrement version numbers

## Key Learnings

### Digests File Format
The digests file contains THREE checksums per file (SHA1, SHA256, MD5), not just SHA256.

### PLIST Regeneration
For complex packages (Erlang-based, large dependency trees), PLIST may need regeneration
from actual build output when library versions change.

### Toolchain Differences
- DSM 7.1 uses GCC 8.5 (older, may need C++ compatibility patches)
- DSM 7.2 uses GCC 12.x (modern C++ features supported)
- Use arch-specific patches in `patches/archname/` for toolchain-specific fixes

### Icon Requirements
Icons should be 512x512 pixels; the framework scales down automatically.

## Architecture Groups

Defined in `mk/spksrc.archs.mk`:
- `x64_ARCHS` - Intel/AMD 64-bit
- `ARMv8_ARCHS` - ARM 64-bit (aarch64)
- `ARMv7_ARCHS` - ARM 32-bit
- `OLD_PPC_ARCHS` - Legacy PowerPC (often unsupported)

## Git Workflow

- Create branches for changes (e.g., `packagename-version` or `fix-issue-description`)
- Avoid slashes in branch names when possible for simpler handling
- Use descriptive commit messages
- Squash commits before PR when appropriate
- Configured user: check `git config user.name` and `git config user.email`

## Detailed Documentation

See `.github/copilot-instructions.md` for comprehensive build system documentation.
