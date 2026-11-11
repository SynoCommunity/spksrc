###############################################################################
# spksrc.native-toolchain.mk
#
# Generic front-end for host-native packages that (re)build a cross toolchain
# COMPONENT (rust, gcc, ...) against an EXISTING Synology toolchain's sysroot.
# Parametrized by (TC_ARCH, TC_VERS); each target gets its own work dir
# work-<arch>-<tcversion> (like cross packages), so every (arch, DSM) is visible
# and independent.
#
#   PKG_NAME = rustc
#   include ../../mk/spksrc.native-toolchain.mk
#
# This file holds only what is common to any component: the (arch, DSM)
# parametrization, the extracted-sysroot fields (TC_TARGET / TC_GCC / TC_GLIBC), the
# per-arch work dir, and tc-install. The component-specific logic (config,
# build/install targets, archive vars) lives in mk/spksrc.native-toolchain/$(PKG_NAME).mk,
# included once the toolchain is known; spksrc.native-cc.mk comes last, so that file can
# set the CONFIGURE/COMPILE/INSTALL targets before native-cc.mk wires them.
#
#   mk/spksrc.native-toolchain/
#   ├── binutils.mk      : PKG_NAME = binutils
#   ├── gcc.mk           : PKG_NAME = gcc
#   ├── rustc.mk         : PKG_NAME = rustc
#   └── pgo-sources.sh   : writes the PGO training sources (toolchain-pgo-sources)
#
# Provides to the component mk and the package:
#   TC_DIR       toolchain/syno-<arch>-<vers>
#   _tc_get      $(call _tc_get,VAR) -> VAR as declared in the toolchain Makefile
#                (read_makefile_var, spksrc.common/macros.mk)
#   TC_TARGET    target triple            TC_GCC / TC_GLIBC  toolchain gcc/glibc
#   TC_EXTRACT_DIR  where tc-install lands the gcc toolchain (bin/, sysroot, ...)
#   TC_SYSROOT_DIR  the extracted toolchain's sysroot (from the declared TC_SYSROOT)
#   tc-install   runs the base toolchain's own build, overlays included, whose cookies make
#                it a no-op once done; not a DEPENDS, which would hand it this WORK_DIR
#   TC_VENDOR_ENV  the prefix a $(shell) running a vendor tool needs (the C locale)
#   TOOLCHAIN_BUILD_TRIPLE  the --build/--host a component configures with, never the target's
#   HOST_OPTFLAGS  how the host compiler should build the component (opt in through
#                  NATIVE_CFLAGS & co), profile-guided under TOOLCHAIN_PGO
#   TOOLCHAIN_DIST_ARCH     the arch the archive is named after (overlay_dist_arch)
#   TOOLCHAIN_BINUTILS_*    the binutils a component builds against, profile-guided, for
#                           the same (arch, DSM): _VERSION, _DIR (native/binutils-<v>), _BIN,
#                           _ARCHIVE, and _MAKE, the command that makes it
#   TOOLCHAIN_PGO_SOURCES   the generated training sources (toolchain-pgo-sources)
#
# What a component sets:
#   TOOLCHAIN_CONSUMER      the overlay directory suffix its consumers carry
#   TOOLCHAIN_CONSUMER_EXACT  that of this build's own consumer, where the first is a pattern
#   ARCHIVE_NAME & co       its archive, named after TOOLCHAIN_DIST_ARCH where
#   TOOLCHAIN_DIST_SHARED   = 1 says a generic arch shares the real arch's archive
#   TOOLCHAIN_PGO           ?= 1 to build twice, profile-guided
#   TOOLCHAIN_PGO_TRAIN     the target running the instrumented tools (pass 1, PGO_PHASE=gen)
#
# Knobs, on the command line:
#   TOOLCHAIN_JOBS          archs all-<vers> builds at once (default 1)
#   TOOLCHAIN_KEEP_WORK     0 drops a work dir once its archive exists (default 1, gcc 0)
#   TOOLCHAIN_PGO           0 for one plain pass
#   PKG_REV                 vN instead of one past the consumer's revision
#
# And the targets that build it:
#   make arch-<arch>-<vers>             one toolchain: build, then archive
#   make all-<vers>                     every toolchain the component has a consumer for
#   make TOOLCHAIN_JOBS=5 all-<vers>    five at a time, each still at full parallelism
#
# all-<vers> concurrency is xargs -P, deliberately NOT make's -j: -j goes into MAKEFLAGS
# and propagates into every sub-make, parallelising toolchain targets not written for it.
# TOOLCHAIN_KEEP_WORK = 0 drops each work dir once its archive exists; a failed one is
# kept, so a broken arch stays debuggable.
###############################################################################

TOOLCHAIN_JOBS      ?= 1
TOOLCHAIN_KEEP_WORK ?= 1

# The C locale for everything a producer runs: the vendor gcc it builds with aborts under any
# other on DSM 5.2 (a loadlocale.c assertion on the host's locale data). C, not C.UTF-8: the
# only locale glibc does not load from files. $(shell) gets it from TC_VENDOR_ENV.
export LC_ALL := C

ifeq ($(strip $(TC_ARCH)),)
$(error spksrc.native-toolchain.mk: TC_ARCH is required (e.g. TC_ARCH=ppc853x))
endif
ifeq ($(strip $(TC_VERS)),)
$(error spksrc.native-toolchain.mk: TC_VERS is required (e.g. TC_VERS=5.2))
endif
ifeq ($(wildcard $(CURDIR)/../../mk/spksrc.native-toolchain/$(PKG_NAME).mk),)
$(error spksrc.native-toolchain.mk: no component for PKG_NAME '$(PKG_NAME)' (mk/spksrc.native-toolchain/<name>.mk))
endif

# overlay.mk keys its lookups off _OVERLAY_TC = syno$(or $(TC_ARCH_SUFFIX),$(ARCH_SUFFIX)),
# and a native package leaves ARCH_SUFFIX at -native. Declare the real (arch, DSM) before
# spksrc.common.mk, which brings the arch groups and macros every component reads.
TC_ARCH_SUFFIX ?= -$(TC_ARCH)-$(TC_VERS)
include ../../mk/spksrc.common.mk

TC      = syno-$(TC_ARCH)-$(TC_VERS)
TC_DIR  = $(abspath $(CURDIR)/../../toolchain/$(TC))
# $(call _tc_get,VAR): value of VAR as declared in the toolchain Makefile -- the
# single source of truth, so nothing here duplicates the toolchain's own fields.
_tc_get = $(call read_makefile_var,$(TC_DIR)/Makefile,$(1))

TC_TARGET  := $(call _tc_get,TC_TARGET)
TC_GCC     := $(call _tc_get,TC_GCC)
TC_GLIBC   := $(call _tc_get,TC_GLIBC)

# Where tc-install lands the gcc toolchain (its bin/, sysroot, ...). Shared by the
# components. NB: distinct from the framework's TC_WORK_DIR (the consumer toolchain).
TC_EXTRACT_DIR = $(TC_DIR)/work/$(TC_TARGET)

# Prefix for running a binary of that toolchain from $(shell): the C locale. The gcc 4.7.3
# of x86-5.2 (and x64-5.2) aborts on a current host's locale data -- "loadlocale.c:129:
# _nl_intern_locale_data: Assertion ... failed". The export above reaches recipes, but
# $(shell) only from make 4.4.
TC_VENDOR_ENV = LC_ALL=C

# The build and host triple a component configures with, its own, as crosstool-NG does.
# Sharing the target's -- an x86_64 target on an x86_64 build host -- autoconf configures a
# native tool: gcc links its target libraries with the host's binutils instead of
# --with-build-time-tools, ld honours the host's LD_LIBRARY_PATH and LD_RUN_PATH.
TOOLCHAIN_BUILD_TRIPLE = $(shell uname -m)-build_pc-linux-gnu

# The extracted toolchain's sysroot, composed from the toolchain's declared TC_SYSROOT
# (single source of truth -- the same value tc_vars emits as SYSROOT). A plain string, so
# valid before extraction too, unlike a wildcard probe. Used e.g. for binutils --with-sysroot.
# TC_SYSROOT's declared value references $(TC_TARGET); _tc_get returns it as raw text, so run
# it through $(eval) to expand that reference (a single make pass would leak a literal $$).
$(eval TC_SYSROOT_DIR := $(TC_EXTRACT_DIR)/$(call _tc_get,TC_SYSROOT))

# Per-(arch,dsm) work dir, cross-style; pre-set so native-cc.mk keeps it (the
# native default would be -native).
WORK_DIR       = $(CURDIR)/work-$(TC_ARCH)-$(TC_VERS)
INSTALL_PREFIX = /usr/local

# tc_vars.mk supplies these on the cross side and is never generated here, yet
# tc-capability.mk's libatomic probe composes the compiler path out of them.
TC_PREFIX   ?= $(TC_TARGET)-
TC_WORK_DIR ?= $(TC_DIR)/work

TOOLCHAIN_DIST_ARCH := $(call overlay_dist_arch,$(TC_ARCH),$(TC_VERS))

# The revision a build produces: one past its consumer's PKG_REV (toolchain_published_rev),
# v1 where it has none yet. It holds until the consumer moves to it, so a batch resumes on
# the same name.
TOOLCHAIN_CONSUMER_EXACT ?= $(TOOLCHAIN_CONSUMER)
_toolchain_rev           = $(call toolchain_published_rev,$(TC_ARCH),$(TC_VERS),$(TOOLCHAIN_CONSUMER_EXACT))
PKG_REV ?= v$(if $(_toolchain_rev),$(shell echo $$(($(patsubst v%,%,$(_toolchain_rev)) + 1))),1)

# The binutils gcc and rust are built against: native/binutils-<v> for this (arch, DSM),
# made by its own arch- target -- both PGO passes and the archive, the very file the
# binutils overlay publishes, at its revision -- or left as it is when that archive exists. The version the
# binutils overlay ships, 2.30 where the arch has none yet; named after the real arch
# (TOOLCHAIN_DIST_ARCH), which binutils builds a generic one as.
TOOLCHAIN_BINUTILS_VERSION := $(or $(OVERLAY_BINUTILS_VERSION),2.30)
TOOLCHAIN_BINUTILS_DIR      = $(BASEDIR)/native/binutils-$(TOOLCHAIN_BINUTILS_VERSION)
TOOLCHAIN_BINUTILS_REV      = $(or $(call toolchain_published_rev,$(TOOLCHAIN_DIST_ARCH),$(TC_VERS),binutils-$(TOOLCHAIN_BINUTILS_VERSION)),v1)
TOOLCHAIN_BINUTILS_WORK     = $(TOOLCHAIN_BINUTILS_DIR)/work-$(TOOLCHAIN_DIST_ARCH)-$(TC_VERS)
TOOLCHAIN_BINUTILS_BIN      = $(TOOLCHAIN_BINUTILS_WORK)/install/usr/local/bin
TOOLCHAIN_BINUTILS_ARCHIVE  = $(TOOLCHAIN_BINUTILS_DIR)/binutils-$(TOOLCHAIN_BINUTILS_VERSION)-$(TC_TARGET)-$(TOOLCHAIN_DIST_ARCH)-$(TC_VERS)-$(TOOLCHAIN_BINUTILS_REV).txz
# The command. MAKEFLAGS= and binutils' own PKG_REV keep this producer's command line out
# of it -- a PKG_REV=vN would rename binutils' archive -- PGO_PHASE= this producer's pass,
# ARCH= TCVERSION= its stage0. An archive whose work dir was dropped since is extracted
# back where that work dir installed: it is that build.
TOOLCHAIN_BINUTILS_MAKE     = MAKEFLAGS= $(MAKE) --no-print-directory -C $(TOOLCHAIN_BINUTILS_DIR) \
                              ARCH= TCVERSION= PGO_PHASE= PKG_REV=$(TOOLCHAIN_BINUTILS_REV) \
                              arch-$(TOOLCHAIN_DIST_ARCH)-$(TC_VERS) && \
                              { test -x $(TOOLCHAIN_BINUTILS_BIN)/$(TC_TARGET)-ld || \
                                { mkdir -p $(TOOLCHAIN_BINUTILS_WORK)/install && \
                                  tar -xJf $(TOOLCHAIN_BINUTILS_ARCHIVE) -C $(TOOLCHAIN_BINUTILS_WORK)/install ; } ; }

# ---- How the host compiler builds the component --------------------------------------
# Probed, not assumed: -march=x86-64-v3 is a GCC 11 spelling and a host without AVX2 must
# still be able to build this; LTO is a single-stage -flto, --with-build-config=bootstrap-lto
# needing a bootstrap a cross compiler cannot do.
_host_cc_ok     = $(shell echo 'int main(){return 0;}' | $(or $(CC),cc) $(1) -x c - -o /dev/null 2>/dev/null && echo 1)
_HOST_OPTFLAGS := -O2 $(if $(call _host_cc_ok,-march=x86-64-v3),-march=x86-64-v3) \
                      $(if $(call _host_cc_ok,-flto=auto),-flto=auto -ffat-lto-objects)

# TOOLCHAIN_PGO (a component default, usually ?= 1): arch-<arch>-<vers> builds twice --
# instrumented, then run through the component's TOOLCHAIN_PGO_TRAIN target on the
# generated sources, then rebuilt reading the counts. PGO_PHASE is set by that recipe; a
# plain `make all` stays a single ordinary pass.
TOOLCHAIN_PGO_DIR     = $(CURDIR)/work-$(TC_ARCH)-$(TC_VERS)-profile
TOOLCHAIN_PGO_SOURCES = $(WORK_DIR)/pgo-src
_PGO_GEN = -fprofile-generate=$(TOOLCHAIN_PGO_DIR) -fprofile-update=atomic
# -Wno-error=coverage-mismatch is REQUIRED, not cosmetic: it is an error by default, and
# configure compiles a succession of different conftest.c all defining main(), so the
# counters never match and every configure in the tree fails to find a working compiler.
_PGO_USE = -fprofile-use=$(TOOLCHAIN_PGO_DIR) -fprofile-correction \
           -Wno-missing-profile -Wno-error=coverage-mismatch -Wno-coverage-mismatch

HOST_OPTFLAGS  = $(_HOST_OPTFLAGS)
HOST_OPTFLAGS += $(if $(filter gen,$(PGO_PHASE)),$(_PGO_GEN))
HOST_OPTFLAGS += $(if $(filter use,$(PGO_PHASE)),$(_PGO_USE))

# Pass 1 of a profile-guided build is instrumented: it never reaches the archive name, which
# is how a finished build is recognised (toolchain-arch below).
ifneq ($(filter gen,$(PGO_PHASE)),)
ARCHIVE_TARGET = toolchain-pgo-no-archive
endif

# Component-specific logic: configuration, build/install targets, archive variables.
include ../../mk/spksrc.native-toolchain/$(PKG_NAME).mk

# Install the target toolchain, overlays included -- exactly what a cross package gets. A
# producer needs more than the vendor gcc (a rustc built ON a gcc overlay needs that overlay).
# Idempotent and cookie-guarded; a component's PRE_CONFIGURE_TARGET depends on it.
#
# Caveat: an arch whose rust consumer pins a rev that was never published cannot resolve its
# DEPENDS, so its very first archive must be produced with that consumer dir moved aside.
.PHONY: tc-install
tc-install:
	@$(MSG) "native-toolchain: ensuring $(TC) is installed ($(TC_ARCH)-$(TC_VERS))"
	@# No WORK_DIR, alone in its family: a producer is addressed by TC, so the framework's
	@# TC_WORK_DIR is empty here and the extraction belongs in the sub-make's own default.
	@# MAKEFLAGS= : this producer's command line is its own -- a PKG_REV=vN would otherwise
	@# reach every overlay consumer installed with the toolchain, and name an archive that
	@# does not exist.
	@MAKEFLAGS= $(MAKE) $(FWRD_ARGS) --no-print-directory -C ../../toolchain/$(TC) toolchain

# ---- One toolchain, then a whole DSM version ------------------------------------------
# TOOLCHAIN_DIST_SHARED (set by a component whose ARCHIVE_NAME carries TOOLCHAIN_DIST_ARCH):
# a generic arch (x64, armv7, aarch64) shares its toolchain, hence its archive, with a real
# arch of the same DSM (overlay_dist_arch), and is built AS that arch. arch-x64-7.1 builds
# apollolake-7.1: the file x64-7.1's consumer fetches, from the toolchain it is a copy of
# (toolchain_real, spksrc.common/macros/archs.mk).
# A variable, so its commas do not split the $(if) below.
_TC_GENERIC_MSG = $*: a generic arch, built as $(_TC_REAL), whose archive it fetches

.PHONY: arch-%
arch-%:
	@$(eval _TC_REAL := $(call toolchain_real,$*))
	@$(if $(filter-out $*,$(_TC_REAL)),$(MSG) "$(_TC_GENERIC_MSG)")
	@$(MAKE) --no-print-directory TC_ARCH=$(firstword $(subst -, ,$(_TC_REAL))) TC_VERS=$(lastword $(subst -, ,$(_TC_REAL))) toolchain-arch

# One (arch, DSM), in the sub-make that knows it, hence its archive name: nothing to do when
# that archive exists -- an underlying arch already built for another generic one, or an
# all-<vers> resumed after a failure. Remove the archive to rebuild.
.PHONY: toolchain-arch
ifneq ($(wildcard $(ARCHIVE_NAME).$(ARCHIVE_EXT)),)
toolchain-arch:
	@$(MSG) "===== $(PKG_NAME)-$(PKG_VERS): $(TC_ARCH)-$(TC_VERS) -- $(ARCHIVE_NAME).$(ARCHIVE_EXT) already built, nothing to do ====="
else
toolchain-arch:
	@$(MSG) "===== $(PKG_NAME)-$(PKG_VERS): $(TC_ARCH)-$(TC_VERS) ====="
ifneq ($(call is_true,$(TOOLCHAIN_PGO)),)
	@$(MSG) "===== $(PKG_NAME)-$(PKG_VERS): $(TC_ARCH)-$(TC_VERS) -- PGO pass 1/2 (instrumented) ====="
	@rm -rf $(WORK_DIR) $(TOOLCHAIN_PGO_DIR)
	@$(MAKE) --no-print-directory TC_ARCH=$(TC_ARCH) TC_VERS=$(TC_VERS) PGO_PHASE=gen all
	@$(MAKE) --no-print-directory TC_ARCH=$(TC_ARCH) TC_VERS=$(TC_VERS) PGO_PHASE=gen $(TOOLCHAIN_PGO_TRAIN)
	@$(MSG) "===== $(PKG_NAME)-$(PKG_VERS): $(TC_ARCH)-$(TC_VERS) -- PGO pass 2/2 (optimised) ====="
	@rm -rf $(WORK_DIR)
	@$(MAKE) --no-print-directory TC_ARCH=$(TC_ARCH) TC_VERS=$(TC_VERS) PGO_PHASE=use all
	@rm -rf $(TOOLCHAIN_PGO_DIR)
else
	@$(MAKE) --no-print-directory TC_ARCH=$(TC_ARCH) TC_VERS=$(TC_VERS) all
endif
	@$(MAKE) --no-print-directory TC_ARCH=$(TC_ARCH) TC_VERS=$(TC_VERS) build-archive
endif

.PHONY: toolchain-pgo-no-archive
toolchain-pgo-no-archive:
	@$(MSG) "*** PGO: instrumented build, not archived"

# The training input, generated per arch: three parallel builds sharing one directory
# clobbered one another.
.PHONY: toolchain-pgo-sources
toolchain-pgo-sources:
	@sh $(BASEDIR)/mk/spksrc.native-toolchain/pgo-sources.sh $(TOOLCHAIN_PGO_SOURCES)

# The toolchains a component is built for are its consumers (toolchain_archs,
# spksrc.common/macros/archs.mk), once each. An arch whose archive exists is skipped
# (toolchain-arch), so a batch resumes where it stopped.
.PHONY: all-%
all-%:
	@$(eval _TC_ARCHS := $(call toolchain_archs,$*))
	@$(MSG) "===== $(PKG_NAME)-$(PKG_VERS): all-$* -- $(words $(_TC_ARCHS)) archs, $(TOOLCHAIN_JOBS) at a time ====="
	@echo "$(_TC_ARCHS)" | tr ' ' '\n' | \
	   xargs -P $(TOOLCHAIN_JOBS) -I@ sh -c '$(MAKE) --no-print-directory arch-@-$* && \
	     { $(if $(call is_true,$(TOOLCHAIN_KEEP_WORK)),true,rm -rf work-@-$*) ; }'
	@$(MSG) "===== $(PKG_NAME)-$(PKG_VERS): all-$* complete ====="

# Last: native-cc.mk wires the targets the component set above.
include ../../mk/spksrc.native-cc.mk
