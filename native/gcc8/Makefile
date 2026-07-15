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

include ../../mk/spksrc.native-toolchain.mk

GCC8_STAGE = $(INSTALL_DIR)$(INSTALL_PREFIX)

# gcc must use the co-built (or stock) binutils: point --with-build-time-tools
# at it and put it on PATH for the build.
ENV += PATH=$(TC_BINUTILS):$$PATH
# The native env empties CC/CXX/AR/... (to force fresh configure detection), but
# building gcc itself needs the HOST toolchain (host programs + build tools like
# genparams). Restore them for this package.
ENV += CC=gcc CXX=g++ CPP="gcc -E" CC_FOR_BUILD=gcc CXX_FOR_BUILD=g++
ENV += AR=ar AS=as LD=ld NM=nm RANLIB=ranlib OBJCOPY=objcopy OBJDUMP=objdump READELF=readelf STRIP=strip

# GNU_CONFIGURE already adds --prefix=$(INSTALL_PREFIX).
CONFIGURE_ARGS  = --target=$(TC_TARGET)
CONFIGURE_ARGS += --with-sysroot=$(TC_SYSROOT_DIR) --with-build-sysroot=$(TC_SYSROOT_DIR)
CONFIGURE_ARGS += --with-native-system-header-dir=/usr/include
CONFIGURE_ARGS += --with-build-time-tools=$(TC_BINUTILS)
CONFIGURE_ARGS += --with-gmp=$(STAGING_INSTALL_PREFIX) --with-mpfr=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-mpc=$(STAGING_INSTALL_PREFIX) --with-isl=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --program-prefix=$(TC_TARGET)- --program-suffix=-8.5
CONFIGURE_ARGS += $(GCC8_TARGET_ABI)
# Fortran is enabled to match DSM-7.2, which ships gfortran; the gmp/mpfr/mpc/isl
# deps it needs are already present for C/C++.
CONFIGURE_ARGS += --enable-languages=c,c++,fortran --enable-__cxa_atexit --enable-threads=posix
CONFIGURE_ARGS += --disable-multilib --disable-bootstrap --disable-nls --disable-werror
CONFIGURE_ARGS += --disable-libsanitizer

COMPILE_ARGS = MAKEINFO=missing
INSTALL_ARGS = install DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX) MAKEINFO=missing

.PHONY: gcc8_prepare
gcc8_prepare: tc-extract
	# co-build a clean binutils 2.30 for this exact arch when the toolchain's
	# own binutils is an old broken vendor fork (see BINUTILS_MODE in the mk).
	@if [ "$(BINUTILS_MODE)" = "cobuild" ]; then \
	  $(MSG) "gcc8: co-building binutils 2.30 for $(TC_ARCH)-$(TC_VERS)" ; \
	  $(MAKE) --no-print-directory -C ../binutils-2.30 TC_ARCH=$(TC_ARCH) TC_VERS=$(TC_VERS) ; \
	else \
	  $(MSG) "gcc8: reusing toolchain binutils ($(TC_BINUTILS))" ; \
	fi

.PHONY: gcc8_post_install
gcc8_post_install: $(INSTALL_TARGET)
	# For cobuild archs the stock binutils is too old to assemble what gcc-8.5
	# emits at RUNTIME (e.g. cortex-a9 -> -march=armv7-a+mp+sec). Bundle the
	# co-built binutils into gcc-8.5's PRIVATE exec dir; the driver finds them
	# there (relative to itself, before the tooldir/PATH) -> self-contained and
	# portable, no clash with the stock toolchain's own assembler.
	@if [ "$(BINUTILS_MODE)" = "cobuild" ] ; then \
	  gccexec=$(GCC8_STAGE)/libexec/gcc/$(TC_TARGET)/$(PKG_VERS) ; \
	  for tool in as ld ld.bfd nm ar ranlib objcopy objdump strip ; do \
	    [ -x "$(TC_BINUTILS)/$(TC_TARGET)-$$tool" ] && cp -a "$(TC_BINUTILS)/$(TC_TARGET)-$$tool" "$$gccexec/$$tool" ; \
	  done ; \
	  $(MSG) "gcc8: bundled co-built binutils into $$gccexec (cobuild arch)" ; \
	fi

##############################################################################
# Packaging (llvm-14.0-build style): tar the gcc-8.5 tree for hosting; consumed
# by the toolchain overlay toolchain/syno-<arch>-<vers>-gcc8. Only the gcc /
# target parts are archived (the NATIVE_DEPENDS host math libs are left out).
#   make TC_ARCH=<arch> TC_VERS=<vers> build-archive
##############################################################################
GCC8_ARCHIVE = gcc8-$(TC_TARGET)-$(TC_VERS).txz
GCC8_ARCHIVE_DIRS = bin libexec lib/gcc $(TC_TARGET)
.PHONY: build-archive
build-archive:
	@$(MSG) "Archiving gcc-8.5 for $(TC_ARCH)-$(TC_VERS) -> $(GCC8_ARCHIVE)"
ifeq ($(wildcard $(GCC8_STAGE)/bin/$(TC_TARGET)-gcc-8.5),)
	$(error "gcc-8.5 not installed; run 'make TC_ARCH=$(TC_ARCH) TC_VERS=$(TC_VERS)' first")
endif
	tar -C $(GCC8_STAGE) -cJf $(GCC8_ARCHIVE) $(GCC8_ARCHIVE_DIRS)

##############################################################################
# Convenience: build gcc8 for EVERY toolchain of a given DSM version.
#   make all-6.2.4     make all-7.0     make all-7.1
##############################################################################
.PHONY: all-%
all-%:
	@for tc in $(sort $(notdir $(wildcard ../../toolchain/syno-*-$*))); do \
	  arch=$$(echo $$tc | sed 's/^syno-//; s/-$*$$//') ; \
	  $(MSG) "===== gcc8: $$arch-$* =====" ; \
	  $(MAKE) --no-print-directory TC_ARCH=$$arch TC_VERS=$* all || exit 1 ; \
	done
