PKG_NAME = binutils
PKG_VERS = 2.30
PKG_EXT  = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/binutils
PKG_DIR  = $(PKG_NAME)-$(PKG_VERS)

# Target toolchain to build a cross-binutils for (per-arch work dir). Defaults to
# ppc853x-5.2, whose stock ld (GNU 2.18.50, 2008) is the one being replaced.
TC_ARCH ?= ppc853x
TC_VERS ?= 5.2

HOMEPAGE = https://www.gnu.org/software/binutils/
COMMENT  = GNU Binutils
LICENSE  = GPLv3

# v3: rebuilt with the host optimisation flags actually reaching the compiler.
# v4: same again, profile-guided. Every consumer pins the same rev (overlay/*_binutils-2.30).
PKG_REV ?= v4

# Builds the archive the binutils overlay installs: mk/spksrc.native/toolchain-binutils.mk.
#   make arch-ppc853x-5.2        make all-6.2.4        make TOOLCHAIN_PGO=0 arch-x86-5.2
NATIVE_TOOLCHAIN = binutils
include ../../mk/spksrc.native-toolchain.mk
