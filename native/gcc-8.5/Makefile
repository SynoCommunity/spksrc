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

GNU_CONFIGURE        = 1
BUILD_DIR            = $(WORK_DIR)/build-gcc
PRE_CONFIGURE_TARGET = gcc-prepare

##############################################################################
# Publishable archive, same shape as native/binutils-2.30 and native/rustc-1.82:
# one component, one archive. gcc ships NO as/ld -- those stay binutils' job, and
# the consumer wires the two together (see the overlay-link target there).
#
# Declared BEFORE the native front-end include so the archive helper sees
# ARCHIVE_NAME; TC_TARGET (=) resolves later. Bump PKG_REV when a rebuild changes
# what is inside without changing a version already encoded in the name, so the
# rebuild lands under a new name instead of replacing a file consumers cached.
##############################################################################
PKG_REV ?= v1
ARCHIVE_NAME = gcc-$(PKG_VERS)-$(TC_TARGET)-$(TC_ARCH)-$(TC_VERS)-$(PKG_REV)
ARCHIVE_EXT  = txz
ARCHIVE_DIR  = $(WORK_DIR)/install
ARCHIVE_KEEP = usr/local
ARCHIVE_STRIP = 1
ARCHIVE_STRIP_TARGET = $(GCC_BINUTILS_BIN)/$(TC_TARGET)-strip
ARCHIVE_STRIP_TARGET_DIRS = $(TC_TARGET) lib/gcc/$(TC_TARGET)
# Host docs and the NATIVE_DEPENDS math libs share this prefix; neither belongs in
# a compiler archive. An exclusion list rather than a dir allow-list, because the
# C++ headers and runtime libs sit under <triple>/ for a cross arch but under the
# native include/c++ + lib/ for a host==target one.
ARCHIVE_EXCLUDES  = --exclude=./share/man --exclude=./share/info --exclude=./share/locale --exclude=./share/gcc-$(PKG_VERS)
ARCHIVE_EXCLUDES += --exclude=./var
ARCHIVE_EXCLUDES += --exclude='*/pkgconfig'
# libtool archives bake this build's DESTDIR into libdir; a consumer that follows one
# looks for a path that only exists here. Consumers drop them too, for archives already out.
ARCHIVE_EXCLUDES += --exclude='*.la'
ARCHIVE_EXCLUDES += --exclude='*/libgmp*'
ARCHIVE_EXCLUDES += --exclude='*/libmpfr*'
ARCHIVE_EXCLUDES += --exclude='*/libmpc*'
ARCHIVE_EXCLUDES += --exclude='*/libisl*'
ARCHIVE_EXCLUDES += --exclude='*/gmp.h'
ARCHIVE_EXCLUDES += --exclude='*/mpfr.h'
ARCHIVE_EXCLUDES += --exclude='*/mpf2mpfr.h'
ARCHIVE_EXCLUDES += --exclude='*/mpc.h'
ARCHIVE_EXCLUDES += --exclude='./include/isl'

# Generic native-toolchain front-end, as for binutils.
NATIVE_TOOLCHAIN = gcc
include ../../mk/spksrc.native-toolchain.mk

# Per-arch ABI, derived from the toolchain's own stock gcc. Provides GCC_TARGET_ABI;
# needs TC_EXTRACT_DIR / TC_TARGET, hence after the front-end include.
include ../../mk/spksrc.toolchain/gcc-abi.mk

# The cross-binutils gcc is BUILT against: native/binutils-2.30's per-arch output.
# One path for every arch -- the prototype's cobuild/reuse split existed only
# because binutils was not yet a component of its own.
GCC_BINUTILS_DIR = $(BASEDIR)/native/binutils-2.30
GCC_BINUTILS_BIN = $(GCC_BINUTILS_DIR)/work-$(TC_ARCH)-$(TC_VERS)/install/usr/local/bin
ENV += PATH=$(GCC_BINUTILS_BIN):$$PATH

# GNU_CONFIGURE already adds --prefix=$(INSTALL_PREFIX).
CONFIGURE_ARGS  = --target=$(TC_TARGET)

# The sysroot must be RELOCATABLE: this archive is extracted somewhere else entirely.
# GCC only makes it so when the configured sysroot lies UNDER the configured prefix
# (gcc/configure.ac tests exactly that, and defines TARGET_SYSTEM_ROOT_RELOCATABLE);
# the driver then recomputes its prefix from its own location on every invocation.
# An absolute --with-sysroot into the base toolchain's work dir bakes in a path that
# points nowhere once the archive moves -- ld cannot find crt1.o and every configure
# fails on "C compiler cannot create executables".
#
# The consumer is what makes the relative form true: it symlinks the base toolchain's
# sysroot to exactly this path inside its own work dir (gcc-sysroot-link there), so
# the overlay stays self-contained AND resolves the real headers.
#
# --with-build-sysroot keeps the real absolute path for the build itself (libgcc and
# libstdc++ compile against the target's headers); it is never recorded in the compiler.
GCC_SYSROOT_SUFFIX = $(notdir $(GCC_BUILD_SYSROOT))
CONFIGURE_ARGS += --with-sysroot=$(INSTALL_PREFIX)/$(TC_TARGET)/$(GCC_SYSROOT_SUFFIX)
CONFIGURE_ARGS += --with-build-sysroot=$(GCC_BUILD_SYSROOT)
# The sysroot the target's OWN compiler uses -- the single source of truth, as in
# gcc-abi.mk. A toolchain Makefile can declare something else: ppc853x-5.2 says TC_SYSROOT
# = $(TC_TARGET) while its gcc reports $(TC_TARGET)/libc, and building against the wrong
# one fails deep in libgcc with "cannot find crti.o". Empty when the stock gcc has no
# sysroot configured (x86-5.2), hence the fallback.
_GCC_STOCK_SYSROOT  = $(realpath $(shell $(_GCC_ABI_STOCK) -print-sysroot 2>/dev/null))
GCC_BUILD_SYSROOT   = $(or $(_GCC_STOCK_SYSROOT),$(TC_SYSROOT_DIR))
# Probe rather than tabulate: whichever of the two layouts actually holds the headers.
GCC_SYSROOT_HEADERS = $(if $(wildcard $(GCC_BUILD_SYSROOT)/usr/include/stdio.h),/usr/include,/include)
CONFIGURE_ARGS += --with-native-system-header-dir=$(GCC_SYSROOT_HEADERS)
CONFIGURE_ARGS += --with-build-time-tools=$(GCC_BINUTILS_BIN)
CONFIGURE_ARGS += --with-gmp=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-mpfr=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-mpc=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-isl=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --program-prefix=$(TC_TARGET)-
# What gives the drivers their -8.5 suffix, which is how tc_vars selects this
# compiler over the stock one (spksrc.toolchain/overlay-gcc.mk).
CONFIGURE_ARGS += --program-suffix=-$(basename $(PKG_VERS))
CONFIGURE_ARGS += $(GCC_TARGET_ABI)
# Fortran to match DSM 7.1, which ships gfortran; its gmp/mpfr/mpc/isl are already here.
CONFIGURE_ARGS += --enable-languages=c,c++,fortran
CONFIGURE_ARGS += --enable-__cxa_atexit
CONFIGURE_ARGS += --enable-threads=posix
# Runtimes under $(libdir)/gcc/$(target)/$(version)/ instead of $(libdir), so this
# compiler resolves its own C++17-capable libstdc++ from its versioned directory and
# never competes with the toolchain's stock one.
CONFIGURE_ARGS += --enable-version-specific-runtime-libs
CONFIGURE_ARGS += --disable-multilib
CONFIGURE_ARGS += --disable-bootstrap
CONFIGURE_ARGS += --disable-nls
CONFIGURE_ARGS += --disable-werror
CONFIGURE_ARGS += --disable-libsanitizer

# Record the ABI this compiler was BUILT with, as the -m flags a package must be given.
# The base toolchain's TC_EXTRA_BUILD_FLAGS describes the vendor gcc: same intent, but
# written for a compiler ten years older, and nothing keeps the two in step. A consumer
# reads this file back so an overlay build is driven by the ABI its own compiler has --
# and a future rebuild with a different one carries packages along instead of silently
# disagreeing. Derived from GCC_TARGET_ABI, so there is one source for both.
GCC_ABI_MFLAGS = $(strip \
  $(patsubst --with-cpu=%,-mcpu=%,$(filter --with-cpu=%,$(GCC_TARGET_ABI))) \
  $(patsubst --with-arch=%,-march=%,$(filter --with-arch=%,$(GCC_TARGET_ABI))) \
  $(if $(findstring arm,$(TC_TARGET)),\
    $(patsubst --with-float=%,-mfloat-abi=%,$(filter --with-float=%,$(GCC_TARGET_ABI))),\
    $(patsubst --with-float=%,-m%-float,$(filter --with-float=%,$(GCC_TARGET_ABI)))) \
  $(patsubst --with-fpu=%,-mfpu=%,$(filter --with-fpu=%,$(GCC_TARGET_ABI))) \
  $(if $(filter --enable-e500_double,$(GCC_TARGET_ABI)),-mfloat-gprs=double))

POST_INSTALL_TARGET = gcc-record-abi

.PHONY: gcc-record-abi
gcc-record-abi:
	@install -d $(INSTALL_DIR)$(INSTALL_PREFIX)/share/spksrc
	@echo "GCC_OVERLAY_ABI = $(GCC_ABI_MFLAGS)" > $(INSTALL_DIR)$(INSTALL_PREFIX)/share/spksrc/gcc-abi.mk
	@$(MSG) "gcc-$(PKG_VERS): recorded ABI [$(GCC_ABI_MFLAGS)]"

COMPILE_ARGS  = MAKEINFO=missing

INSTALL_ARGS  = install
INSTALL_ARGS += DESTDIR=$(INSTALL_DIR)
INSTALL_ARGS += prefix=$(INSTALL_PREFIX)
INSTALL_ARGS += MAKEINFO=missing

.PHONY: gcc-prepare
gcc-prepare: tc-install
	# An empty sysroot would configure a compiler that still builds and only fails
	# much later in a consumer's link, so stop here instead.
	@test -n "$(GCC_SYSROOT_SUFFIX)" || { \
	  $(MSG) "gcc: no sysroot found under $(TC_EXTRACT_DIR)" ; \
	  exit 1 ; \
	}
	@$(MSG) "gcc-$(PKG_VERS): building binutils for $(TC_ARCH)-$(TC_VERS) to build against"
	@$(MAKE) --no-print-directory -C $(GCC_BINUTILS_DIR) TC_ARCH=$(TC_ARCH) TC_VERS=$(TC_VERS)

##############################################################################
# Build (and archive) gcc for a SPECIFIC toolchain of a given DSM version.
#   make arch-qoriq-6.2.4       make arch-x64-7.0
##############################################################################
.PHONY: arch-%
arch-%:
	@$(MSG) "===== gcc-$(PKG_VERS): $* ====="
	@$(MAKE) --no-print-directory TC_ARCH=$(firstword $(subst -, ,$*)) TC_VERS=$(lastword $(subst -, ,$*)) all
	@$(MAKE) --no-print-directory TC_ARCH=$(firstword $(subst -, ,$*)) TC_VERS=$(lastword $(subst -, ,$*)) build-archive

##############################################################################
# Build (and archive) gcc for EVERY toolchain of a given DSM version.
#
#   make all-6.2.4                 one arch at a time
#   make GCC_JOBS=5 all-6.2.4     5 archs at a time (each still max threads)
#
# The consumers ARE the arch list -- one consumer, one archive, so there is no table
# here and no virtual/canonical special case.
#
# Concurrency via xargs -P, deliberately NOT make's -j: -j goes into MAKEFLAGS and
# propagates into every sub-make, parallelising toolchain targets not written for it.
##############################################################################
GCC_ARCHS = $(shell ls -d ../../toolchain/syno-*-$(1)_gcc-8.5_gcc-* 2>/dev/null | \
                    sed 's|.*/syno-||; s|-$(1)_gcc-8.5_gcc-.*||')
GCC_JOBS ?= 1
# A gcc build tree is ~2 GB and only the .txz matters afterwards: 59 of them would fill
# the disk long before a full batch ends. Kept on failure, so a broken arch stays
# debuggable; GCC_KEEP_WORK=1 keeps them all.
GCC_KEEP_WORK ?= 0

.PHONY: all-%
all-%:
	@$(MSG) "===== gcc-$(PKG_VERS): all-$* -- $(words $(call GCC_ARCHS,$*)) archs, $(GCC_JOBS) at a time ====="
	@echo "$(sort $(call GCC_ARCHS,$*))" | tr ' ' '\n' | \
	   xargs -P $(GCC_JOBS) -I@ sh -c '$(MAKE) --no-print-directory arch-@-$* && \
	     { [ "$(GCC_KEEP_WORK)" = "1" ] || rm -rf work-@-$* ; }'
	@$(MSG) "===== gcc-$(PKG_VERS): all-$* complete ====="
