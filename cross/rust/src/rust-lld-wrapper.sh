#!/bin/sh
# Linker wrapper for the bundled rust-lld.
#
# rust-lld is a non-PIE executable, so it cannot be patched to the bundled
# musl loader (patchelf's page-shift corrupts fixed-address binaries); run it
# through the loader explicitly. rustc passes "-flavor gnu" as the first
# argument (linker-flavor=ld.lld) and rust-lld accepts -flavor only as argv[1],
# so all rustc arguments are forwarded before our extra -L, which lets dylib
# links (e.g. proc-macro crates) resolve -lc/-lgcc_s against the bundled musl
# runtime.

SELF=$(readlink -f "$0")
RUST_ROOT=$(dirname "$(dirname "$SELF")")
ROOT=$(dirname "$(dirname "$RUST_ROOT")")
RUST_SUPPORT="$ROOT/share/rust-support"

exec "$RUST_SUPPORT/lib/@MUSL_LOADER@" --library-path "$RUST_SUPPORT/lib" \
    "$RUST_ROOT/lib/rustlib/@RUST_TARGET@/bin/rust-lld" "$@" -L "$RUST_SUPPORT/lib"
