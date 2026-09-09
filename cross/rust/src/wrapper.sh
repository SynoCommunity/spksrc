#!/bin/sh
# Wrapper for the Rust toolchain installed under share/rust.
#
# The PIE toolchain binaries are patched (patchelf) to run against the bundled
# musl runtime in share/rust-support, so they execute directly. What remains
# is to point rustc at the bundled rust-lld: DSM ships no C toolchain, no crt
# objects and no libc.so development files, so rustc cannot link through the
# usual "cc" driver. Combined with the musl target's default crt-static +
# self-contained linking, produced binaries are fully static and run
# standalone on the NAS.

SELF=$(readlink -f "$0")
ROOT=$(dirname "$(dirname "$SELF")")
RUST_ROOT="$ROOT/share/rust"
LLD_WRAP="$RUST_ROOT/bin/rust-lld-wrapper.sh"

# The dynamically linked cargo/rustc has no compiled-in CA bundle path.
export SSL_CERT_FILE="${SSL_CERT_FILE:-/etc/ssl/certs/ca-certificates.crt}"

case "@RUST_TOOL@" in
rustc)
    exec "$RUST_ROOT/bin/rustc" \
        -C linker="$LLD_WRAP" -C linker-flavor=ld.lld "$@"
    ;;
cargo)
    # Route builds through the rustc wrapper so cargo does not invoke the
    # real rustc directly, and configure the target linker for crates.
    export RUSTC="$ROOT/bin/rustc"
    _triple=$(printf '%s' "@RUST_TARGET@" | tr 'a-z-' 'A-Z_')
    eval "export CARGO_TARGET_${_triple}_LINKER=\"$LLD_WRAP\""
    exec "$RUST_ROOT/bin/cargo" "$@"
    ;;
*)
    exec "$RUST_ROOT/bin/@RUST_TOOL@" "$@"
    ;;
esac
