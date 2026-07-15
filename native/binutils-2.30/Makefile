PKG_NAME = binutils
PKG_VERS = 2.30
PKG_EXT  = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/binutils
PKG_DIR  = $(PKG_NAME)-$(PKG_VERS)

# Target toolchain to build a cross-binutils for (per-arch work dir).
TC_ARCH ?= qoriq
TC_VERS ?= 6.2.4

DEPENDS =

HOMEPAGE = https://www.gnu.org/software/binutils/
COMMENT  = GNU binutils 2.30 (the DSM-7.1/7.2 default) rebuilt as a clean cross-assembler/linker for a Synology toolchain target. Used by native/gcc8 for archs whose stock binutils is an old vendor fork gcc-8.5 cannot drive. 2.30 handles every backend gcc-8.5 targets and is new enough for glibc up to 2.26.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --target=$(TC_TARGET)
CONFIGURE_ARGS += --program-prefix=$(TC_TARGET)-
CONFIGURE_ARGS += --with-sysroot=$(TC_SYSROOT_DIR)
CONFIGURE_ARGS += --disable-nls --disable-werror --disable-gdb

include ../../mk/spksrc.native-toolchain.mk
