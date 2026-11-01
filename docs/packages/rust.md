---
title: Rust
description: Rust programming language toolchain (rustc, cargo, rustfmt, clippy) for building pure-Rust crates directly on your NAS
tags:
  - packages
  - development
---

# Rust

!!! note "Package Information"
    - **Maintainer**: @SynoCommunity
    - **Upstream**: [Rust](https://www.rust-lang.org/)
    - **License**: Apache-2.0 / MIT

This package installs the official Rust toolchain on your NAS: the `rustc`
compiler, the `cargo` package manager and build tool, plus `rustfmt` and
`clippy`. It lets you compile Rust programs directly on the device.

## How it works

The package repackages the official `musl` builds of Rust, so the toolchain
does not depend on the DSM glibc version. Since DSM ships no musl loader, the
package bundles its own musl runtime and `libgcc_s` (from Alpine) under
`share/rust-support`, and the toolchain binaries are patched at package build
time to use this bundled runtime. The commands in `/usr/local/bin` are small
wrapper scripts that additionally point `rustc` at the bundled `rust-lld`
linker.

Linking is done through the `rust-lld` linker that is bundled with the
toolchain, so **no separate C toolchain is required on the NAS** to build
pure-Rust crates. Binaries produced by `rustc`/`cargo` are statically linked
(musl crt-static) and run standalone on the NAS — including crates that use
build scripts or procedural macros (e.g. `serde` with the `derive` feature).

The commands below are symlinked into `/usr/local/bin`:

- `rustc`, `cargo`, `rustdoc`, `rustfmt`, `cargo-clippy`, `clippy-driver`, `cargo-fmt`

## Installation

### Prerequisites

- DSM 7.0 or later
- A supported architecture: **x64** or **aarch64**

### Via Package Center

1. Add the SynoCommunity repository to Package Center
   - See [Installation Guide](../user-guide/installation.md)
2. Search for "Rust"
3. Click **Install**

## Usage

### Compile a single file

```bash
rustc hello.rs
./hello
```

### Build a crate with cargo

```bash
cargo new demo
cd demo
cargo build --release
```

The produced binary is statically linked and runs on the NAS without extra
runtime dependencies.

## Limitations

- **Crates that need a C compiler** (for example `openssl-sys`, `ring`, or any
  crate with a C `build.rs`) cannot be built with this package alone. Install
  the *SynoCli Development Tools* package to get `clang`/`lld`, and note that
  DSM still provides no full development sysroot.
- **Architectures**: only x64 and aarch64 are supported, because these are the
  only targets for which upstream Rust publishes host tools (`rustc` + `cargo`).
  armv7, armv5 and PowerPC are not available.

## Architecture Support

| Architecture | DSM 7 | Notes |
|-------------|-------|-------|
| x64 | ✓ | musl host toolchain + bundled musl runtime |
| aarch64 | ✓ | musl host toolchain + bundled musl runtime |
| armv7 | - | No upstream host tools |
| armv5 | - | No upstream host tools |
| PowerPC | - | No upstream host tools |

## See Also

- [SynoCli Development Tools](synocli-devel.md)
- [Rust documentation](https://www.rust-lang.org/learn)
- [Category Index](../packages/index.md)
