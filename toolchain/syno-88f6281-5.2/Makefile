TC_ARCH = 88f6281
TC_VERS = 5.2
TC_KERNEL = 2.6.32
TC_GLIBC = 2.15
TC_GCC = 4.6.4

TC_DIST = 6281-gcc464_glibc215_88f6281-GPL
TC_DIST_SITE_URL = https://github.com/SynoCommunity/spksrc/releases/download/
TC_DIST_SITE_PATH = toolchains%2Fdsm5.2

TC_TARGET = arm-marvell-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/libc
TC_LIBRARY = $(TC_SYSROOT)/usr/lib

# Custom-rust arch: rustup's prebuilt armv5te std targets a newer glibc than DSM 5.2's
# 2.15, so std is rebuilt from source. The rust-<id>.txz is built by native/rustc-1.82
# (arch-88f6281-5.2) and downloaded via the consumer DEPENDS below.
# armv5te is Tier-2 (rustup ships a std), so OVERLAY_RUSTC=0 can fall back to stock rustc.
RUST_TARGET_TIER = 2
TC_RUSTC = 1.82.0

# glibc 2.15: no clock_gettime in libc (<2.17), no native 64-bit atomics. -latomic auto-dropped.
TC_EXTRA_LDFLAGS = -lrt -latomic

include ../../mk/spksrc.toolchain.mk

# Download the published rust .txz (consumer dir carries gcc<ver> so variants coexist).
# Skipped during a native-toolchain extract (NATIVE_TOOLCHAIN_EXTRACT=1) to avoid a
# bootstrap cycle (the consumer would download the archive being produced).
ifneq ($(NATIVE_TOOLCHAIN_EXTRACT),1)
DEPENDS = toolchain/syno-$(TC_ARCH)-$(TC_VERS)-rust-gcc$(TC_GCC)
endif
