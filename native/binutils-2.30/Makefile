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
# The consumers reach for usr/local/bin only. libbfd.a and libopcodes.a are dead weight
# there, and -ffat-lto-objects makes them four times the size of everything else in the
# archive: 7.3 MB and 2.6 MB against 2.3 MB for the whole of x86-5.2's bin/.
CONFIGURE_ARGS += --disable-install-libbfd

# Publishable archive (release asset / CI download), like native/rustc-1.82. Declared
# BEFORE the native front-end include so the archive helper (via native-cc.mk) sees
# ARCHIVE_NAME; TC_TARGET (=) resolves later. The .txz unpacks usr/local/{bin,...} so an
# OVERLAY_BINUTILS consumer finds <target>-{ld,as,...} under usr/local/bin. Bump the rev
# when a rebuilt archive is re-published under the same (arch,DSM,ver) name.
#
# spksrc.native exports CFLAGS="$(NATIVE_CFLAGS)", and NATIVE_CFLAGS has no default: an
# empty CFLAGS reaches both configure and make, and it overrides the -O2 configure would
# otherwise have chosen. The tools were being built with no optimisation at all. ld and
# as run in every link of every package, so give the host compiler something to work with.
#
# Set through NATIVE_CFLAGS rather than appended to ENV: env-default.mk's own
# `ENV += CFLAGS="$$(NATIVE_CFLAGS)"` is appended when the front-end below is included, so
# an ENV line written here is overridden by the later, empty one -- last assignment wins
# in `env VAR=... cmd`. Filling the variable it reads is order-independent.
#
# Probed, not assumed: -march=x86-64-v3 is a GCC 11 spelling and a host without AVX2 must
# still be able to build this.
_host_cc_ok = $(shell echo 'int main(){return 0;}' | $(or $(CC),cc) $(1) -x c - -o /dev/null 2>/dev/null && echo 1)
HOST_OPTFLAGS  = -O2
HOST_OPTFLAGS += $(if $(call _host_cc_ok,-march=x86-64-v3),-march=x86-64-v3)
HOST_OPTFLAGS += $(if $(call _host_cc_ok,-flto=auto),-flto=auto -ffat-lto-objects)

NATIVE_CFLAGS   = $(HOST_OPTFLAGS)
NATIVE_CXXFLAGS = $(HOST_OPTFLAGS)
NATIVE_LDFLAGS  = $(HOST_OPTFLAGS)

# v3: same binutils, rebuilt with the flags above actually reaching the compiler. Every
# consumer pins the same rev.
PKG_REV ?= v3
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
