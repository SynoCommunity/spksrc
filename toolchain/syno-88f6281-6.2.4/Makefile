TC_ARCH = 88f6281
TC_VERS = 6.2.4
TC_KERNEL = 2.6.32
TC_GLIBC = 2.15
TC_GCC = 4.6.4

TC_DIST = 6281-gcc464_glibc215_88f6281-GPL
TC_DIST_SITE_PATH = toolchains%2Fdsm6.2.4

TC_TARGET = arm-marvell-linux-gnueabi
TC_SYSROOT = $(TC_TARGET)/libc

# Custom-rust arch: rustup's prebuilt armv5te std targets a newer glibc than DSM 6.2.4's
# 2.15, so std is rebuilt from source. The rust-<id>.txz is built by native/rustc-1.82
# (arch-88f6281-6.2.4) and downloaded via the rust consumer dir.
# armv5te is Tier-2 (rustup ships a std), so OVERLAY_RUSTC=0 can fall back to stock rustc.
RUST_TARGET_TIER = 2

# glibc 2.15: no clock_gettime in libc (<2.17), no native 64-bit atomics. -latomic auto-dropped.
TC_EXTRA_LDFLAGS = -lrt -latomic

include ../../mk/spksrc.toolchain.mk
