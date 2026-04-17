# Reference

This section provides reference documentation for spksrc development.

## In This Section

- **[Architectures](architectures.md)** - CPU architectures and model mappings
- **[Ports](ports.md)** - Port allocations for Synology and SynoCommunity packages
- **[Makefile Reference](makefile-reference.md)** - Complete variable and target reference
- **[Permissions](permissions.md)** - Service accounts, ACLs, and access control
- **[DSM APIs](dsm-apis.md)** - Synology documentation and external resources

## Quick Links

### Build System

| Topic | Description |
|-------|-------------|
| [Makefile Reference](makefile-reference.md) | Complete variable/target reference |
| [Makefile Variables Guide](../developer-guide/packaging/makefile-variables.md) | Tutorial-style guide |
| [Build Rules](../developer-guide/packaging/build-rules.md) | Build targets and hooks |
| [PLIST Files](../developer-guide/packaging/plist.md) | Package contents |

### Package Types

| Type | Include File |
|------|-------------|
| Standard C/C++ | `spksrc.cross-cc.mk` |
| CMake | `spksrc.cross-cmake.mk` |
| Meson | `spksrc.cross-meson.mk` |
| Go | `spksrc.cross-go.mk` |
| Rust | `spksrc.cross-rust.mk` |
| Python | `spksrc.python.mk` |

For external Synology documentation and resources, see [DSM APIs](dsm-apis.md).
