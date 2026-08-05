TC_ARCH = x86
TC_VERS = 5.2
TC_KERNEL = 3.2.40
TC_GLIBC = 2.17
TC_GCC = 4.7.3

TC_DIST = x64-gcc473_glibc217_x86_64-GPL
TC_DIST_SITE_URL = https://github.com/SynoCommunity/spksrc/releases/download/
TC_DIST_SITE_PATH = toolchains%2Fdsm5.2

TC_TARGET = x86_64-pc-linux-gnu
TC_SYSROOT = $(TC_TARGET)/sys-root
TC_INCLUDE = $(TC_SYSROOT)/include

# Declares this as a custom-rust arch (enters spksrc.toolchain/rustc.mk). The
# prebuilt rust-<id>-<rev>.txz is built by native/rustc-$(TC_RUSTC)
# (make -C native/rustc-1.82 arch-x86-5.2) and downloaded via the consumer DEPENDS.
RUST_BUILD_TOOLCHAIN = 0

# Base triple tier: rustup ships a std (tier 1/2), so RUST_OVERLAY=0 can fall
# back to the stock rustc (a newer-glibc std). tier 3 would be a hard error.
RUST_TARGET_TIER = 1

# Versions available: https://releases.rs/docs/
TC_RUSTC = 1.82.0

# Declare the IN-TREE rust triple; native-toolchain-rust.mk derives the synology
# form (x86_64-synology-linux-gnu) + its JSON target-spec. For x86_64 this is also
# what avoids the host==target collision (host stays x86_64-unknown-linux-gnu, the
# custom target becomes x86_64-synology-linux-gnu) while std is cross-built against
# this DSM-5.2 glibc 2.17.
RUST_TARGET = x86_64-unknown-linux-gnu

# <triple>-<tool> symlink prefixes the built rustc may invoke by name.
RUST_POSTFIX_ALIASES = x86_64-synology-linux-gnu x86_64-unknown-linux-gnu

include ../../mk/spksrc.toolchain.mk

# Download the published prebuilt rustc .txz. The consumer dir carries gcc<ver> so
# a future gcc-8.5 overlay variant coexists. Skipped while a native toolchain
# producer extracts this gcc toolchain to BUILD the .txz (tc-extract passes
# NATIVE_TOOLCHAIN_EXTRACT=1), so the consumer does not try to download the very
# archive being produced (bootstrap cycle).
ifneq ($(NATIVE_TOOLCHAIN_EXTRACT),1)
DEPENDS = toolchain/syno-$(TC_ARCH)-$(TC_VERS)-rust-gcc$(TC_GCC)
endif
