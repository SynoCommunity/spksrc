PKG_NAME = gcc
PKG_VERS = 8.5.0
PKG_EXT  = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/gcc/gcc-$(PKG_VERS)
PKG_DIR  = $(PKG_NAME)-$(PKG_VERS)

# Target toolchain to rebuild gcc-8.5 for (per-arch work dir).
TC_ARCH ?= qoriq
TC_VERS ?= 6.2.4

# Host math libraries gcc-8.5 is built against (arch-independent, same versions
# as gcc-8.5's contrib/download_prerequisites). NATIVE_DEPENDS installs them into
# THIS package's own prefix ($(STAGING_INSTALL_PREFIX)), so --with-* need no
# absolute path. binutils is NOT a plain dep: per-arch, co-built by gcc8_prepare.
NATIVE_DEPENDS  = native/gmp
NATIVE_DEPENDS += native/mpfr
NATIVE_DEPENDS += native/mpc
NATIVE_DEPENDS += native/isl

HOMEPAGE = https://gcc.gnu.org/
COMMENT  = GCC 8.5 (= the DSM-7.1/7.2 compiler) rebuilt as a cross-compiler for an older Synology toolchain, reusing its glibc sysroot. Unlocks modern C++ on DSM 6.2.4 / 7.0 / comcerto2k. glibc stays the runtime floor.
LICENSE  = GPLv3

# Standard autotools, built out-of-tree via the framework's BUILD_DIR support --
# no custom configure/compile/install targets. gcc8_prepare co-builds the arch's
# binutils first; gcc8_post_install bundles it.
GNU_CONFIGURE        = 1
BUILD_DIR            = $(WORK_DIR)/build-gcc
PRE_CONFIGURE_TARGET = gcc8_prepare
POST_INSTALL_TARGET  = gcc8_post_install

##############################################################################
# Packaging via the generic helper (mk/spksrc.native/archive.mk): host the
# gcc-8.5 tree, consumed by the overlay toolchain/syno-<arch>-<vers>-gcc8.
#   make TC_ARCH=<arch> TC_VERS=<vers> build-archive
#
# Declared BEFORE the native front-end include so the helper (pulled in by
# native-cc.mk) sees NATIVE_ARCHIVE; the '=' refs resolve later. Keep the whole
# install prefix EXCEPT host docs (share/var) and the NATIVE_DEPENDS math libs
# (gmp/mpfr/mpc/isl) installed into the same prefix. Exclusion, not a dir
# allow-list, because the C++ headers / runtime libs live in different places per
# target: cross archs put them under <triple>/ (include/c++, lib/libstdc++),
# while a host==target arch (x86_64/i686) uses the native layout include/c++ and
# lib/. Strip target objects (libstdc++, libgcc, crt*.o) with the arch's OWN
# strip, host binaries (driver, cc1/cc1plus, bundled binutils) with the host one.
##############################################################################
NATIVE_ARCHIVE = $(TC_ARCH)-gcc$(subst .,,$(PKG_VERS))_binutils$(subst .,,$(TC_BINUTILS))_glibc$(subst .,,$(TC_GLIBC))_$(firstword $(subst -, ,$(TC_TARGET)))-GPL-dsm$(subst .,,$(TC_VERS)).txz
NATIVE_ARCHIVE_SENTINEL = $(INSTALL_DIR)$(INSTALL_PREFIX)/bin/$(TC_TARGET)-gcc-8.5
NATIVE_ARCHIVE_STRIP = 1
NATIVE_ARCHIVE_STRIP_TARGET = $(TC_BINUTILS_BIN)/$(TC_TARGET)-strip
NATIVE_ARCHIVE_STRIP_TARGET_DIRS = $(TC_TARGET) lib/gcc/$(TC_TARGET)
NATIVE_ARCHIVE_EXCLUDES  = --exclude=./share
NATIVE_ARCHIVE_EXCLUDES += --exclude=./var
NATIVE_ARCHIVE_EXCLUDES += --exclude='*/pkgconfig'
NATIVE_ARCHIVE_EXCLUDES += --exclude='*/libgmp*'
NATIVE_ARCHIVE_EXCLUDES += --exclude='*/libmpfr*'
NATIVE_ARCHIVE_EXCLUDES += --exclude='*/libmpc*'
NATIVE_ARCHIVE_EXCLUDES += --exclude='*/libisl*'
NATIVE_ARCHIVE_EXCLUDES += --exclude='*/gmp.h'
NATIVE_ARCHIVE_EXCLUDES += --exclude='*/mpfr.h'
NATIVE_ARCHIVE_EXCLUDES += --exclude='*/mpf2mpfr.h'
NATIVE_ARCHIVE_EXCLUDES += --exclude='*/mpc.h'
NATIVE_ARCHIVE_EXCLUDES += --exclude='./include/isl'

include ../../mk/spksrc.native-toolchain.mk

GCC8_STAGE = $(INSTALL_DIR)$(INSTALL_PREFIX)

# gcc must use the co-built (or stock) binutils: point --with-build-time-tools
# at it and put it on PATH for the build. The host compiler (CC/CXX/...) comes
# from the native env-default, which now selects it positively.
ENV += PATH=$(TC_BINUTILS_BIN):$$PATH

# GNU_CONFIGURE already adds --prefix=$(INSTALL_PREFIX).
CONFIGURE_ARGS  = --target=$(TC_TARGET)
CONFIGURE_ARGS += --with-sysroot=$(TC_SYSROOT_DIR)
CONFIGURE_ARGS += --with-build-sysroot=$(TC_SYSROOT_DIR)
CONFIGURE_ARGS += --with-native-system-header-dir=/usr/include
CONFIGURE_ARGS += --with-build-time-tools=$(TC_BINUTILS_BIN)
CONFIGURE_ARGS += --with-gmp=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-mpfr=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-mpc=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-isl=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --program-prefix=$(TC_TARGET)-
CONFIGURE_ARGS += --program-suffix=-8.5
CONFIGURE_ARGS += $(GCC8_TARGET_ABI)
# Fortran is enabled to match DSM-7.1, which ships gfortran
# The gmp/mpfr/mpc/isl dependencies it needs are already present for C/C++.
CONFIGURE_ARGS += --enable-languages=c,c++,fortran
CONFIGURE_ARGS += --enable-__cxa_atexit
CONFIGURE_ARGS += --enable-threads=posix
CONFIGURE_ARGS += --disable-multilib
CONFIGURE_ARGS += --disable-bootstrap
CONFIGURE_ARGS += --disable-nls
CONFIGURE_ARGS += --disable-werror
CONFIGURE_ARGS += --disable-libsanitizer

COMPILE_ARGS  = MAKEINFO=missing

INSTALL_ARGS  = install
INSTALL_ARGS += DESTDIR=$(INSTALL_DIR)
INSTALL_ARGS += prefix=$(INSTALL_PREFIX)
INSTALL_ARGS += MAKEINFO=missing

.PHONY: gcc8_prepare
gcc8_prepare: tc-extract
	# co-build a clean binutils for this exact arch when the toolchain's own
	# binutils is an old broken vendor fork (see BINUTILS_MODE in the mk).
	@if [ "$(BINUTILS_MODE)" = "cobuild" ]; then \
	  $(MSG) "gcc8: co-building binutils $(BINUTILS_VERS) for $(TC_ARCH)-$(TC_VERS)" ; \
	  $(MAKE) --no-print-directory -C $(BINUTILS_DIR) TC_ARCH=$(TC_ARCH) TC_VERS=$(TC_VERS) ; \
	else \
	  $(MSG) "gcc8: reusing toolchain binutils ($(TC_BINUTILS_BIN))" ; \
	fi

.PHONY: gcc8_post_install
gcc8_post_install: $(INSTALL_TARGET)
	# Bundle the assembler/linker gcc-8.5 was built against into its PRIVATE
	# exec dir, for EVERY arch. Deployed standalone (in its own install prefix),
	# gcc-8.5's driver looks for `as`/`ld` in libexec/gcc/<target>/<ver>/ before
	# the tooldir/PATH, but nothing there provides them: for cobuild archs the
	# stock binutils is too old to assemble what gcc-8.5 emits (e.g. cortex-a9
	# -> -march=armv7-a+mp+sec), and for reuse archs gcc looks for an unprefixed
	# `as` and falls back to the HOST assembler (which cannot target a non-x86
	# arch -> `as: unrecognized option '-EL'` on aarch64). Bundling from
	# TC_BINUTILS_BIN (the co-built binutils for cobuild, the toolchain's own for
	# reuse) makes the overlay self-contained and relocatable in either case.
	@gccexec=$(GCC8_STAGE)/libexec/gcc/$(TC_TARGET)/$(PKG_VERS) ; \
	for tool in as ld ld.bfd nm ar ranlib objcopy objdump strip ; do \
	  [ -x "$(TC_BINUTILS_BIN)/$(TC_TARGET)-$$tool" ] && cp -a "$(TC_BINUTILS_BIN)/$(TC_TARGET)-$$tool" "$$gccexec/$$tool" ; \
	done ; \
	$(MSG) "gcc8: bundled binutils ($(BINUTILS_MODE)) into $$gccexec"

##############################################################################
# Build gcc8 for EVERY real toolchain of a given DSM version.
#
#   make all-6.2.4                 one arch at a time
#   make GCC8_JOBS=5 all-6.2.4     5 archs at a time (each still max threads)
#
# Concurrency is expressed with xargs -P, deliberately NOT with make's -j: -j goes
# into MAKEFLAGS and propagates down into every sub-make, parallelising package
# and toolchain targets that are not written for it. That is not hypothetical --
# it races the toolchain's rust_toml against its own extract (writing into work/
# before extract creates it). It is also why native-cc.mk sets .NOTPARALLEL and
# why spksrc.common.mk forces PARALLEL_MAKE=nop as soon as it sees -j.
#
# So each arch stays a plain serial make that keeps PARALLEL_MAKE=max for its own
# compile step, and only the archs run concurrently. That is safe because they
# share nothing: depend.mk builds NATIVE_DEPENDS inside the consumer's own
# WORK_DIR, so every arch gets its own gmp/mpfr/mpc/isl next to its gcc, on top of
# its own staging and co-built binutils.
#
# GCC8_JOBS x PARALLEL_MAKE is the real job count. A gcc build only keeps ~9 of
# 24 cores busy on its own (long serial configure/link phases), so a handful of
# concurrent archs is what actually fills the machine.
#
# Virtual/generic archs are skipped: an arch whose name is not its TC_DIST prefix
# while that canonical sibling has its own toolchain (aarch64 -> rtd1296,
# armv7 -> armada38x, x86 -> x64) merely shares the canonical toolchain, so
# building it would duplicate the canonical archive. The prefix test alone is not
# enough -- 88f6281 ships as '6281-...' and has no '6281' sibling, so it is real.
##############################################################################
GCC8_TC_DIST    = $(shell sed -n 's/^TC_DIST *= *//p' ../../toolchain/syno-$(1)-$(2)/Makefile 2>/dev/null)
GCC8_TC_CANON   = $(firstword $(subst -, ,$(call GCC8_TC_DIST,$(1),$(2))))
GCC8_IS_VIRTUAL = $(if $(filter $(1),$(call GCC8_TC_CANON,$(1),$(2))),,$(wildcard ../../toolchain/syno-$(call GCC8_TC_CANON,$(1),$(2))-$(2)))
GCC8_REAL_ARCHS = $(foreach a,$(patsubst syno-%-$(1),%,$(notdir $(wildcard ../../toolchain/syno-*-$(1)))),$(if $(call GCC8_IS_VIRTUAL,$(a),$(1)),,$(a)))

GCC8_JOBS ?= 1

.PHONY: all-%
all-%:
	@$(MSG) "gcc8: all-$* -- $(words $(call GCC8_REAL_ARCHS,$*)) archs, $(GCC8_JOBS) at a time"
	@echo "$(sort $(call GCC8_REAL_ARCHS,$*))" | tr ' ' '\n' | \
	   xargs -P $(GCC8_JOBS) -I@ $(MAKE) --no-print-directory arch-@-$*
	@$(MSG) "gcc8: all-$* complete"

##############################################################################
# Build gcc8 for a SPECIFIC toolchain of a given DSM version.
#   make arch-apollolake-6.2.4     make arch-apollolake-7.0
##############################################################################
.PHONY: arch-%
arch-%:
	@$(MSG) "===== gcc8: $* ====="
	@$(MAKE) --no-print-directory TC_ARCH=$(firstword $(subst -, ,$*)) TC_VERS=$(lastword $(subst -, ,$*)) all
	@$(MAKE) --no-print-directory TC_ARCH=$(firstword $(subst -, ,$*)) TC_VERS=$(lastword $(subst -, ,$*)) build-archive
