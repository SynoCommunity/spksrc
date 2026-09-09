SPK_NAME = rust
SPK_VERS = 1.97.1
SPK_REV = 1
SPK_ICON = src/rust.png

DEPENDS = cross/rust

# Only x64 and aarch64 have upstream Rust host tools (rustc + cargo);
# the musl builds are used so no DSM glibc/sysroot is required.
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS)
REQUIRED_MIN_DSM = 7.0

MAINTAINER = SynoCommunity
DESCRIPTION = Rust programming language toolchain: rustc, cargo, rustfmt, clippy. The package bundles its own musl runtime and links via the bundled rust-lld, so no C toolchain is needed on the NAS for pure-Rust crates; produced binaries are statically linked and run standalone. Crates that need a C compiler such as openssl-sys or ring additionally require a C toolchain like the one in SynoCli Development Tools.
STARTABLE = no
DISPLAY_NAME = Rust
CHANGELOG = "1. Initial release with Rust 1.97.1"

HOMEPAGE = https://www.rust-lang.org/
LICENSE  = Apache-2.0, MIT

SPK_COMMANDS = bin/rustc bin/cargo bin/rustdoc bin/rustfmt bin/cargo-clippy bin/clippy-driver bin/cargo-fmt

include ../../mk/spksrc.spk.mk
