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

# Custom-rust arch: std is cross-built against this DSM-5.2 glibc 2.17. The rust-<id>.txz
# is built by native/rustc-1.82 (arch-x86-5.2) and downloaded via the consumer DEPENDS.
# x86_64 is Tier-1 (rustup ships a std), so OVERLAY_RUSTC=0 can fall back to stock rustc.
RUST_TARGET_TIER = 1
TC_RUSTC = 1.82.0
# The synology triple (from the overlay) also avoids the x86_64 host==target collision.
RUST_POSTFIX_ALIASES = x86_64-synology-linux-gnu x86_64-unknown-linux-gnu

include ../../mk/spksrc.toolchain.mk

# Download the published rust .txz (consumer dir carries gcc<ver> so variants coexist).
# Skipped during a native-toolchain extract (NATIVE_TOOLCHAIN_EXTRACT=1) to avoid a
# bootstrap cycle (the consumer would download the archive being produced).
ifneq ($(NATIVE_TOOLCHAIN_EXTRACT),1)
DEPENDS = toolchain/syno-$(TC_ARCH)-$(TC_VERS)-rust-gcc$(TC_GCC)
endif
