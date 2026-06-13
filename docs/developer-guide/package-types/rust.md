# Rust Packages

Rust packages use the Rust toolchain with Cargo for cross-compilation.

## Basic Setup

```makefile
PKG_NAME = myapp
PKG_VERS = 1.2.3
PKG_DIST_SITE = https://github.com/example/$(PKG_NAME)/releases/download/v$(PKG_VERS)

include ../../mk/spksrc.cross-rust.mk
```

## Cargo Configuration

```makefile
CARGO_BUILD_FLAGS = --release
CARGO_BUILD_FLAGS += --features "feature1 feature2"
```

## C Dependencies

```makefile
DEPENDS = cross/openssl
ENV += OPENSSL_DIR=$(STAGING_INSTALL_PREFIX)
```

## Architecture Mapping

| spksrc Arch | Rust Target |
|-------------|-------------|
| x64 | x86_64-unknown-linux-gnu |
| aarch64 | aarch64-unknown-linux-gnu |
| armv7 | armv7-unknown-linux-gnueabihf |
