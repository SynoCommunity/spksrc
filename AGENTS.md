# AI Agent Instructions for spksrc

This file provides guidance for AI coding assistants working with the spksrc repository.

## Overview

spksrc is a cross-compilation framework for building Synology NAS packages (SPK files). The codebase uses GNU Make extensively with custom Makefile includes.

## Key Principles

1. **Don't push to GitHub without explicit user approval** - Always ask before pushing commits
2. **Test builds before committing** - Run `make arch-x64-7.2` to verify changes compile
3. **Preserve existing patterns** - Follow conventions from similar packages in the repo
4. **Patches must apply cleanly** - No fuzz or offset warnings
5. **Simplicity over cleverness** - If a simpler solution works for all cases, prefer it over complex conditionals
6. **Always rebase against master before merging** - Keep branch history clean

## Directory Conventions

- `cross/` - Libraries and applications cross-compiled for target architecture
- `diyspk/` - Do-it-yourself SPK templates for standalone versions of bundled packages
- `spk/` - Final SPK package definitions that users install
- `native/` - Tools built for the host system (used during cross-compilation)
- `mk/` - Framework Makefiles (avoid modifying unless necessary)
- `toolchain/` - Synology toolchain definitions (rarely modified)
- `kernel/` - Synology modified kernel sources for building modules

## Common Operations

### Building a Package
```bash
make setup                 # Initial setup (creates local.mk) - run once
cd spk/packagename
make arch-x64-7.2  # Build for specific architecture
make all-supported # Build all supported architectures
make clean         # Clean build artifacts
```

### Updating Package Version
1. Edit `PKG_VERS` in `cross/packagename/Makefile`
2. Run `make digests` to update checksums
3. Edit `SPK_VERS` in `spk/packagename/Makefile`, increment `SPK_REV`
4. Update `CHANGELOG`
5. Test with `make arch-x64-7.2`

For major version upgrades, check upstream release notes for breaking changes, dependency compatibility, and migration requirements.

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
- DSM 7.2 uses GCC 8.5
- DSM 7.1 uses GCC 7.x (except comcerto2k which uses older GCC)
- DSM 6.2.4 uses GCC 4.9.x (except ARMv5/88f6281 which uses GCC 4.6.4)
- ARMv5/88f6281 (GCC 4.6.4) does not support `-std=c11` - use `-std=gnu99`
- Use arch-specific patches in `patches/archname/` for toolchain-specific fixes
- Atomic support varies by architecture (some require libatomic linking)
- When a flag works across all toolchains, use it universally rather than complex conditionals

### Python Multi-Version Support
- When using `ifeq` conditionals with arch variables, include `spksrc.common.mk` first to define `ARMv5_ARCHS`, etc.
- Python wheels have four types: pure-python, crossenv, abi3-limited, and cross-package
- Pin all wheel versions exactly (e.g., `mercurial==6.5.1`); never include setuptools/pip/wheel
- See copilot-instructions.md for detailed Python package patterns

### Icon Requirements
Icons should be 512x512 pixels; the framework scales down automatically.

## Architecture Groups

Defined in `mk/spksrc.common/archs.mk`:
- `x64_ARCHS` - Intel/AMD 64-bit
- `ARMv8_ARCHS` - ARM 64-bit (aarch64)
- `ARMv7_ARCHS` - ARM 32-bit
- `ARMv7L_ARCHS` - Legacy ARM 32-bit (hi3535)
- `ARMv5_ARCHS` - Legacy ARM (88f6281) - GCC 4.6.4, limited C standard support
- `PPC_ARCHS` - PowerPC (qoriq, ppc853x, etc.)
- `OLD_PPC_ARCHS` - Legacy PowerPC (often unsupported)
- `32bit_ARCHS` - All 32-bit architectures
- `64bit_ARCHS` - All 64-bit architectures

## Git Workflow

- **Always work in feature branches** - never commit directly to master
- Branch naming: `packagename-version` or `fix-issue-description` (no `/` in branch names)
- **Never push without explicit approval** - always ask first
- **Never amend commits already pushed to GitHub** - create new commits instead
- **Always rebase against master before merging** - keep branch history clean
- Configured user: check `git config user.name` and `git config user.email`

### Commit Messages
- Use `DISPLAY_NAME:` prefix from `spk/*/Makefile` (e.g., `Borg: Use gnu99 for GCC < 5.0`)
- Use `Framework:` prefix for mk/ changes (not filename prefix)
- Keep messages concise but descriptive
- Keep commit messages in sync with PR title/description

## Code Style

- **Keep related items separated but simple** - e.g., each wheel's CFLAGS in its own block, but don't nest conditionals unnecessarily
- **Remove redundant code** - don't leave dead code paths
- **Check existing patterns first** - look at how similar packages solve the same problem before inventing new approaches
- **Question necessity** - before making framework changes, verify they're truly required by comparing working vs failing cases

## CI/Build Failures

- Analyze CI logs carefully rather than guessing at fixes
- Compare working vs failing builds to isolate differences
- Check if the issue is arch-specific (toolchain version, available libraries)
- Upload CI logs for review when debugging complex failures
- Local builds may differ from CI (e.g., pre-existing work directories affect dependency resolution)
- Updating widely-used dependencies (zlib, openssl) triggers many package rebuilds - isolate in separate PRs

## Detailed Documentation

See `.github/copilot-instructions.md` for comprehensive build system documentation.
