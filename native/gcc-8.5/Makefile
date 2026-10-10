PKG_NAME = gcc
PKG_VERS = 8.5.0
PKG_EXT  = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/gcc/gcc-$(PKG_VERS)
PKG_DIR  = $(PKG_NAME)-$(PKG_VERS)

# Target toolchain to rebuild gcc-8.5 for (per-arch work dir).
TC_ARCH ?= qoriq
TC_VERS ?= 6.2.4

# Host math libraries gcc-8.5 is built against (arch-independent, same versions as
# gcc-8.5's contrib/download_prerequisites). NATIVE_DEPENDS installs them into THIS
# package's own prefix, so --with-* need no absolute path.
NATIVE_DEPENDS  = native/gmp
NATIVE_DEPENDS += native/mpfr
NATIVE_DEPENDS += native/mpc
NATIVE_DEPENDS += native/isl

HOMEPAGE = https://gcc.gnu.org/
COMMENT  = GNU Compiler Collection
LICENSE  = GPLv3

# Bump when a rebuild changes what is inside without changing a version already encoded
# in the archive name, so it lands under a new name instead of replacing a file consumers
# cached. v5: profile-guided. Every consumer pins the same rev (overlay/*_gcc-8.5).
PKG_REV ?= v5

# Builds the archive the gcc overlay installs: mk/spksrc.native/toolchain-gcc.mk.
#   make arch-qoriq-6.2.4        make all-6.2.4        make TOOLCHAIN_PGO=0 arch-x86-5.2
NATIVE_TOOLCHAIN = gcc
include ../../mk/spksrc.native-toolchain.mk
