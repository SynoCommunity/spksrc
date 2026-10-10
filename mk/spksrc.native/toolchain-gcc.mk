###############################################################################
# spksrc.native/toolchain-gcc.mk
#
# Component logic for NATIVE_TOOLCHAIN = gcc (spksrc.native-toolchain.mk): a modern cross
# gcc rebuilt against an EXISTING Synology toolchain's sysroot, published as the archive
# the gcc overlay installs (spksrc.overlay/gcc.mk). One component, one archive: it ships
# NO as/ld -- those stay binutils', and the consumer wires the two together.
#
# The package states the version, its archive revision and the host math libraries:
#
#   PKG_NAME = gcc
#   PKG_VERS = 8.5.0
#   PKG_REV ?= v5
#   NATIVE_TOOLCHAIN = gcc
#   include ../../mk/spksrc.native-toolchain.mk
###############################################################################

GNU_CONFIGURE        = 1
BUILD_DIR            = $(WORK_DIR)/build-gcc
PRE_CONFIGURE_TARGET = gcc-prepare

# The overlay directories this component's consumers carry: all-<vers> builds for them.
TOOLCHAIN_CONSUMER = gcc-$(basename $(PKG_VERS))

# Profile-guided by default: measured on x86-5.2, five runs each on inputs the training
# never saw, cc1 is 8.5% faster on a 300 KB C file at -O2 and 12.5% at -O3, cc1plus 11.7%
# on 490 KB of templates and STL; cc1 shrinks 31.2 -> 27.7 MB, cc1plus 33.1 -> 29.6 MB.
# The generated code is bit-identical -- PGO moves the compiler, not what it emits.
#
# `make profiledbootstrap` is NOT available here: a cross configuration forces
# --disable-bootstrap, so gcc never rebuilds itself and there is no stage to profile.
# TOOLCHAIN_PGO drives the same idea by hand.
TOOLCHAIN_PGO       ?= 1
TOOLCHAIN_PGO_TRAIN  = gcc-pgo-train
# A gcc build tree is ~2 GB and only the .txz matters afterwards: a whole DSM version's
# worth of them would fill the disk long before the batch ends.
TOOLCHAIN_KEEP_WORK ?= 0

##############################################################################
# Publishable archive. Declared before the native front-end include so the archive
# helper sees ARCHIVE_NAME; TC_TARGET (=) resolves later.
##############################################################################
ARCHIVE_NAME = gcc-$(PKG_VERS)-$(TC_TARGET)-$(TOOLCHAIN_DIST_ARCH)-$(TC_VERS)-$(PKG_REV)
# Named after TOOLCHAIN_DIST_ARCH: a generic arch is built as the real arch it shares it with.
TOOLCHAIN_DIST_SHARED = 1
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

##############################################################################
# Target ABI, derived from the toolchain's OWN stock gcc -- the single source of truth --
# plus the fixups a GCC >= 8 needs. No table to maintain, no toolchain Makefile edits.
# Lazy (=): it resolves once the toolchain is extracted, which is a build prerequisite.
#
#   * --with-cpu present   -> drop --with-arch / --with-tune (GCC >= 8 rejects the combo)
#   * --with-cpu=marvell-f -> --with-arch=armv5te (unknown to mainline GCC)
#   * hard-float 32-bit ARM with no fpu -> --with-fpu=neon (Synology ARM is Cortex-A9+)
#   * powerpc SPE (-gnuspe triple)      -> --enable-obsolete (removed in GCC 9)
#   * --enable-default-pie present      -> carried, so the overlay links as the stock one
##############################################################################
_GCC_ABI_STOCK = $(TC_EXTRACT_DIR)/bin/$(TC_TARGET)-gcc
_GCC_ABI_RAW   = $(shell test -x $(_GCC_ABI_STOCK) && $(_GCC_ABI_STOCK) -v 2>&1 | tr ' ' '\n' | \
                   grep -iE '^--with-(arch|cpu|tune|float|fpu)=|^--enable-(e500_double|default-pie)$$' | sort -u)

_GCC_ABI_ARCH  = $(filter --with-arch=%,$(_GCC_ABI_RAW))
_GCC_ABI_CPU   = $(filter --with-cpu=%,$(_GCC_ABI_RAW))
_GCC_ABI_FLOAT = $(filter --with-float=%,$(_GCC_ABI_RAW))
_GCC_ABI_FPU   = $(filter --with-fpu=%,$(_GCC_ABI_RAW))
_GCC_ABI_E500  = $(filter --enable-e500_double,$(_GCC_ABI_RAW))

# cpu wins over arch/tune; marvell-f is a vendor name mainline GCC does not know
_GCC_ABI_BASE = $(if $(_GCC_ABI_CPU),\
                  $(if $(findstring marvell-f,$(_GCC_ABI_CPU)),--with-arch=armv5te,$(_GCC_ABI_CPU)),\
                  $(_GCC_ABI_ARCH))
# The stock gcc does not always DECLARE its float ABI -- ppc853x-5.2's 2008 compiler leans
# on --with-cpu=8548 implying it, which a modern gcc no longer does. Fall back to what the
# toolchain asserts: getting this wrong is silent, and yields soft-float runtime libs
# against a hard-float glibc.
_GCC_ABI_TC_FLAGS = $(call _tc_get,TC_EXTRA_BUILD_FLAGS)
_GCC_ABI_FLOAT2   = $(or $(_GCC_ABI_FLOAT),\
                      $(if $(filter -mhard-float -mfloat-abi=hard,$(_GCC_ABI_TC_FLAGS)),--with-float=hard),\
                      $(if $(filter -msoft-float -mfloat-abi=soft,$(_GCC_ABI_TC_FLAGS)),--with-float=soft))

# The fpu, in order of authority: what the stock gcc declares, then what the toolchain
# tells packages to use, then a guess. No Synology ARM gcc declares one, and the guess
# alone used to say neon -- armada370/375/xp have none, so their libgcc and libstdc++ came
# out full of NEON that only faults on the device.
#
# What the stock compiler DEFAULTS to answers even when it declares nothing, and it is the
# Synology gcc speaking. Every ARM toolchain lands here, answering "vfp" where
# TC_EXTRA_BUILD_FLAGS names something narrower -- vfp is what the vendor's own libgcc and
# libstdc++ were built with, and the overlay replaces exactly those. ARM only: a PowerPC
# gcc answers "none", which configure would take literally.
_GCC_ABI_DEF_FPU = $(if $(findstring arm,$(TC_TARGET)),$(patsubst %,--with-fpu=%,$(word 2,$(shell $(_GCC_ABI_STOCK) -Q --help=target 2>/dev/null | grep -E '^[[:space:]]+-mfpu=[[:space:]]'))))
# TC_EXTRA_BUILD_FLAGS is deliberately NOT consulted here, though it is the authority for
# compiling PACKAGES: it is per-model, and alpine's neon-vfpv4 would give this compiler a
# libstdc++ that no longer serves the generic armv7 arch every ARMv7 package builds through.
_GCC_ABI_FPU2 = $(or $(_GCC_ABI_FPU),$(_GCC_ABI_DEF_FPU),\
                  $(if $(and $(findstring hard,$(_GCC_ABI_FLOAT2)),$(findstring arm,$(TC_TARGET))),--with-fpu=neon))
_GCC_ABI_OBS  = $(if $(findstring gnuspe,$(TC_TARGET)),--enable-obsolete)

# Default-PIE follows the stock compiler: DSM 7.1 and SRM 1.3 turn it on, everything
# older does not, and an overlay that disagreed would quietly change how a package links.
_GCC_ABI_PIE  = $(filter --enable-default-pie,$(_GCC_ABI_RAW))

GCC_TARGET_ABI = $(strip $(_GCC_ABI_BASE) $(_GCC_ABI_FLOAT2) $(_GCC_ABI_FPU2) $(_GCC_ABI_E500) $(_GCC_ABI_OBS) $(_GCC_ABI_PIE))

##############################################################################
# Build configuration
##############################################################################

# The cross-binutils gcc is BUILT against: native/binutils-<vers>'s per-arch output.
GCC_BINUTILS_DIR = $(BASEDIR)/native/binutils-2.30
GCC_BINUTILS_BIN = $(GCC_BINUTILS_DIR)/work-$(TC_ARCH)-$(TC_VERS)/install/usr/local/bin
ENV += PATH=$(GCC_BINUTILS_BIN):$$PATH

# GCC's build defaults CFLAGS to -g -O2, but only when CFLAGS is unset; spksrc.native
# exports it empty, which leaves cc1 and cc1plus at -O0 and the compiler ~3x slower.
NATIVE_CFLAGS   = $(HOST_OPTFLAGS)
NATIVE_CXXFLAGS = $(HOST_OPTFLAGS)
NATIVE_LDFLAGS  = $(HOST_OPTFLAGS)

# Where host==target (the x86-64 archs), configure copies CFLAGS into CFLAGS_FOR_TARGET --
# which would ship a v3 libstdc++ to Goldmont NAS CPUs that have no AVX2. Pin what a cross
# already gets.
ENV += CFLAGS_FOR_TARGET="-g -O2" CXXFLAGS_FOR_TARGET="-g -O2"

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
# sysroot to exactly this path inside its own work dir (spksrc.overlay/gcc.mk), so the
# overlay stays self-contained AND resolves the real headers.
#
# --with-build-sysroot keeps the real absolute path for the build itself (libgcc and
# libstdc++ compile against the target's headers); it is never recorded in the compiler.
GCC_SYSROOT_SUFFIX = $(notdir $(GCC_BUILD_SYSROOT))
CONFIGURE_ARGS += --with-sysroot=$(INSTALL_PREFIX)/$(TC_TARGET)/$(GCC_SYSROOT_SUFFIX)
CONFIGURE_ARGS += --with-build-sysroot=$(GCC_BUILD_SYSROOT)
# The sysroot the target's OWN compiler uses -- the single source of truth, as for the ABI
# above. A toolchain Makefile can declare something else: ppc853x-5.2 says TC_SYSROOT =
# $(TC_TARGET) while its gcc reports $(TC_TARGET)/libc, and building against the wrong one
# fails deep in libgcc with "cannot find crti.o". Empty when the stock gcc has no sysroot
# configured (x86-5.2), hence the fallback.
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
# What gives the drivers their -<major.minor> suffix, which is how tc_vars selects this
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

COMPILE_ARGS  = MAKEINFO=missing

INSTALL_ARGS  = install
INSTALL_ARGS += DESTDIR=$(INSTALL_DIR)
INSTALL_ARGS += prefix=$(INSTALL_PREFIX)
INSTALL_ARGS += MAKEINFO=missing

.PHONY: gcc-record-abi
gcc-record-abi:
	@install -d $(INSTALL_DIR)$(INSTALL_PREFIX)/share/spksrc
	@echo "GCC_OVERLAY_ABI = $(GCC_ABI_MFLAGS)" > $(INSTALL_DIR)$(INSTALL_PREFIX)/share/spksrc/gcc-abi.mk
	@$(MSG) "gcc-$(PKG_VERS): recorded ABI [$(GCC_ABI_MFLAGS)]"

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

# PGO training: the instrumented compiler over the generated sources (TOOLCHAIN_PGO_SOURCES),
# so the counters describe compilation, not just whatever the build happened to do. The
# driver's own prefix has no sysroot in the work tree, so --sysroot must be named: without
# it every training run dies on "stdlib.h: No such file or directory" and the profile
# silently ends up describing only the target-library build.
_GCC_PGO_BIN = $(INSTALL_DIR)$(INSTALL_PREFIX)/bin/$(TC_TARGET)-
_GCC_PGO_SFX = -$(basename $(PKG_VERS))

.PHONY: gcc-pgo-train
gcc-pgo-train: toolchain-pgo-sources
	@$(MSG) "*** PGO: training on train.c and train.cpp"
	@cd $(TOOLCHAIN_PGO_SOURCES) && \
	  $(_GCC_PGO_BIN)gcc$(_GCC_PGO_SFX) --sysroot=$(GCC_BUILD_SYSROOT) -O2 -S -o /dev/null train.c && \
	  $(_GCC_PGO_BIN)gcc$(_GCC_PGO_SFX) --sysroot=$(GCC_BUILD_SYSROOT) -O3 -S -o /dev/null train.c && \
	  $(_GCC_PGO_BIN)g++$(_GCC_PGO_SFX) --sysroot=$(GCC_BUILD_SYSROOT) -O2 -S -o /dev/null train.cpp
	@$(MSG) "*** PGO: $$(find $(TOOLCHAIN_PGO_DIR) -name '*.gcda' 2>/dev/null | wc -l) counter files"
