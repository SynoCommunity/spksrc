# Package Types

spksrc supports various package types, each with specific build requirements and configurations.

## Overview

| Type | Include File | Use Case |
|------|--------------|----------|
| Python | `spksrc.python.mk` | Applications with Python wheels |
| Go | `spksrc.cross-go.mk` | Single-binary Go applications |
| Rust | `spksrc.cross-rust.mk` | Rust applications |
| Web | `spksrc.spk.mk` + WebStation | PHP/HTML web applications |
| Standard | `spksrc.spk.mk` | C/C++ applications or scripts |

## Choosing the Right Type

**Python packages** - Applications with pip dependencies, virtualenv isolation.

**Go packages** - Single-binary apps, performance-critical services.

**Rust packages** - Memory-safe system applications, CLI tools.

**Web applications** - PHP apps running under WebStation.

## Next Steps

- [Python Packages](python.md)
- [Go Packages](go.md)
- [Rust Packages](rust.md)
- [Web Applications](web.md)
