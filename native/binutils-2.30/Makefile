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

GNU_CONFIGURE = 1
# Install the target toolchain first so --with-sysroot resolves (tc-install, generic).
PRE_CONFIGURE_TARGET = tc-install
CONFIGURE_ARGS  = --target=$(TC_TARGET)
CONFIGURE_ARGS += --program-prefix=$(TC_TARGET)-
CONFIGURE_ARGS += --with-sysroot=$(TC_SYSROOT_DIR)
CONFIGURE_ARGS += --disable-nls --disable-werror --disable-gdb

# Publishable archive (release asset / CI download), like native/rustc-1.82. Declared
# BEFORE the native front-end include so the archive helper (via native-cc.mk) sees
# ARCHIVE_NAME; TC_TARGET (=) resolves later. The .txz unpacks usr/local/{bin,...} so an
# OVERLAY_BINUTILS consumer finds <target>-{ld,as,...} under usr/local/bin. Bump the rev
# when a rebuilt archive is re-published under the same (arch,DSM,ver) name.
PKG_REV ?= v1
ARCHIVE_NAME = binutils-$(PKG_VERS)-$(TC_TARGET)-$(TC_ARCH)-$(TC_VERS)-$(PKG_REV)
ARCHIVE_EXT  = txz
ARCHIVE_DIR  = $(WORK_DIR)/install
ARCHIVE_KEEP = usr/local

# Generic native-toolchain front-end dispatches to mk/spksrc.native/toolchain-binutils.mk.
NATIVE_TOOLCHAIN = binutils
include ../../mk/spksrc.native-toolchain.mk

##############################################################################
# Build (and archive) binutils for a SPECIFIC toolchain of a given DSM version.
#   make arch-ppc853x-5.2      make arch-qoriq-6.2.4
# The co-built tools land in work-<arch>-<vers>/install/usr/local/bin as
# <target>-{ld,as,ar,...}; OVERLAY_BINUTILS consumers point at that bin dir. The
# archive step publishes the same tree as a .txz for the release / CI download.
##############################################################################
.PHONY: arch-%
arch-%:
	@$(MSG) "===== binutils-$(PKG_VERS): $* ====="
	@$(MAKE) --no-print-directory TC_ARCH=$(firstword $(subst -, ,$*)) TC_VERS=$(lastword $(subst -, ,$*)) all
	@$(MAKE) --no-print-directory TC_ARCH=$(firstword $(subst -, ,$*)) TC_VERS=$(lastword $(subst -, ,$*)) build-archive

##############################################################################
# Build (and archive) binutils for EVERY toolchain of a given DSM version.
#
#   make all-6.2.4                 one arch at a time
#   make BINUTILS_JOBS=5 all-6.2.4     5 archs at a time (each still max threads)
#
# The consumers ARE the arch list -- one consumer, one archive, so there is no table
# here and no virtual/canonical special case.
#
# Concurrency via xargs -P, deliberately NOT make's -j: -j goes into MAKEFLAGS and
# propagates into every sub-make, parallelising toolchain targets not written for it.
##############################################################################
BINUTILS_ARCHS = $(shell ls -d ../../toolchain/syno-*-$(1)_binutils-2.30_gcc-* 2>/dev/null | \
                    sed 's|.*/syno-||; s|-$(1)_binutils-2.30_gcc-.*||')
BINUTILS_JOBS ?= 1

.PHONY: all-%
all-%:
	@$(MSG) "===== binutils-$(PKG_VERS): all-$* -- $(words $(call BINUTILS_ARCHS,$*)) archs, $(BINUTILS_JOBS) at a time ====="
	@echo "$(sort $(call BINUTILS_ARCHS,$*))" | tr ' ' '\n' | \
	   xargs -P $(BINUTILS_JOBS) -I@ $(MAKE) --no-print-directory arch-@-$*
	@$(MSG) "===== binutils-$(PKG_VERS): all-$* complete ====="
