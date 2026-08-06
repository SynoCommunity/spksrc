TC_ARCH = 88f6281
TC_VERS = 6.2.4
TC_KERNEL = 2.6.32
TC_GLIBC = 2.15
TC_GCC = 4.6.4

TC_DIST = 6281-gcc464_glibc215_88f6281-GPL
TC_DIST_SITE_PATH = toolchains%2Fdsm6.2.4

TC_TARGET = arm-marvell-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/libc

# Custom Rust toolchain: rustup's prebuilt armv5te std targets a newer glibc than the
# DSM 6.2.4 glibc 2.15, so std is (re)built from source against this toolchain. armv5te
# is a Tier-2 target so RUST_TARGET (armv5te-unknown-linux-gnueabi) needs no aliases.
# Declares this as a custom-rust arch (enters spksrc.toolchain/rustc.mk). The
# prebuilt rust-<id>-<rev>.txz is built by native/rustc-$(TC_RUSTC)
# (make -C native/rustc-1.82 arch-88f6281-6.2.4) and downloaded via the consumer
# DEPENDS below.
RUST_BUILD_TOOLCHAIN = 0

# Base triple tier: rustup ships a std (tier 1/2), so OVERLAY_RUSTC=0 can fall
# back to the stock rustc (a newer-glibc std). tier 3 would be a hard error.
RUST_TARGET_TIER = 2


# Versions available: https://releases.rs/docs/
TC_RUSTC = 1.82.0

# Rust target triple to build std for (declared here so env-rust.mk's arch map is
# not consulted -- single source of truth for the from-source toolchain).
RUST_TARGET = armv5te-unknown-linux-gnueabi

# glibc 2.15 predates clock_gettime in libc (2.17); the target has no native 64-bit atomics.
# -latomic is dropped automatically when the gcc does not ship it.
TC_EXTRA_LDFLAGS = -lrt -latomic

include ../../mk/spksrc.toolchain.mk

# Download the published prebuilt rustc .txz. The consumer dir carries gcc<ver> so
# a future gcc-8.5 overlay variant coexists. Skipped while a native toolchain
# producer extracts this gcc toolchain to BUILD the .txz (tc-extract passes
# NATIVE_TOOLCHAIN_EXTRACT=1), so the consumer does not try to download the very
# archive being produced (bootstrap cycle).
ifneq ($(NATIVE_TOOLCHAIN_EXTRACT),1)
DEPENDS = toolchain/syno-$(TC_ARCH)-$(TC_VERS)-rust-gcc$(TC_GCC)
endif
