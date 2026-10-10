###############################################################################
# spksrc.native-toolchain.mk
#
# Generic front-end for host-native packages that (re)build a cross toolchain
# COMPONENT (rust, gcc, ...) against an EXISTING Synology toolchain's sysroot.
# Parametrized by (TC_ARCH, TC_VERS); each target gets its own work dir
# work-<arch>-<tcversion> (like cross packages), so every (arch, DSM) is visible
# and independent.
#
#   NATIVE_TOOLCHAIN = rust
#   include ../../mk/spksrc.native-toolchain.mk
#
# This file holds only what is common to any component: the (arch, DSM)
# parametrization, the toolchain-Makefile reader (_tc_get), the extracted-sysroot
# fields (TC_TARGET / TC_GCC / TC_GLIBC), the per-arch work dir, and tc-install.
# The component-specific logic (config, build/install targets, archive vars) lives
# in mk/spksrc.native/toolchain-$(NATIVE_TOOLCHAIN).mk, included below; the front-
# end include of spksrc.native-cc.mk follows it so that specific file can set the
# CONFIGURE/COMPILE/INSTALL targets before native-cc.mk wires them.
#
# Provides to the component mk and the package:
#   TC_DIR       toolchain/syno-<arch>-<vers>
#   _tc_get      $(call _tc_get,VAR) -> VAR as declared in the toolchain Makefile
#   TC_TARGET    target triple            TC_GCC / TC_GLIBC  toolchain gcc/glibc
#   TC_EXTRACT_DIR  where tc-install lands the gcc toolchain (bin/, sysroot, ...)
#   TC_SYSROOT_DIR  the extracted toolchain's sysroot (from the declared TC_SYSROOT)
#   tc-install   ensures the gcc toolchain (hence its sysroot) is extracted
#   HOST_OPTFLAGS  how the host compiler should build the component (opt in through
#                  NATIVE_CFLAGS & co), profile-guided under TOOLCHAIN_PGO
#   TOOLCHAIN_DIST_ARCH  the arch the archive is named after (spksrc.overlay/dist-arch.mk)
#
# And the targets that build it:
#   make arch-<arch>-<vers>             one toolchain: build, then archive
#   make all-<vers>                     every toolchain the component has a consumer for
#   make TOOLCHAIN_JOBS=5 all-<vers>    five at a time, each still at full parallelism
#
# A component sets TOOLCHAIN_CONSUMER, the overlay directory suffix its consumers carry
# (gcc-8.5, binutils-2.30, rust-1.98_gcc-*), which is how all-<vers> knows its archs.
###############################################################################

ifeq ($(strip $(TC_ARCH)),)
$(error spksrc.native-toolchain.mk: TC_ARCH is required (e.g. TC_ARCH=ppc853x))
endif
ifeq ($(strip $(TC_VERS)),)
$(error spksrc.native-toolchain.mk: TC_VERS is required (e.g. TC_VERS=5.2))
endif
ifeq ($(strip $(NATIVE_TOOLCHAIN)),)
$(error spksrc.native-toolchain.mk: NATIVE_TOOLCHAIN is required (e.g. NATIVE_TOOLCHAIN=rust))
endif

TC          = syno-$(TC_ARCH)-$(TC_VERS)
TC_DIR      = $(abspath $(CURDIR)/../../toolchain/$(TC))
# $(call _tc_get,VAR): value of VAR as declared in the toolchain Makefile -- the
# single source of truth, so nothing here duplicates the toolchain's own fields.
_tc_get     = $(shell sed -n 's/^$(1)[[:space:]]*=[[:space:]]*//p' $(TC_DIR)/Makefile 2>/dev/null)

TC_TARGET  := $(call _tc_get,TC_TARGET)
TC_GCC     := $(call _tc_get,TC_GCC)
TC_GLIBC   := $(call _tc_get,TC_GLIBC)

# Where tc-install lands the gcc toolchain (its bin/, sysroot, ...). Shared by the
# components. NB: distinct from the framework's TC_WORK_DIR (the consumer toolchain).
TC_EXTRACT_DIR = $(TC_DIR)/work/$(TC_TARGET)

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

# The arch the archive is named after: TC_ARCH, or the real arch whose toolchain a generic
# one shares -- the same answer its consumer gets, so the published name is the fetched one.
include ../../mk/spksrc.overlay/dist-arch.mk
TOOLCHAIN_DIST_ARCH := $(call overlay_dist_arch,$(TC_ARCH),$(TC_VERS))

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
	@$(MAKE) $(FWRD_ARGS) --no-print-directory -C ../../toolchain/$(TC) toolchain

# Component-specific logic: configuration, build/install targets, archive variables.
include ../../mk/spksrc.native/toolchain-$(NATIVE_TOOLCHAIN).mk

# overlay.mk keys its lookups off _OVERLAY_TC = syno$(or $(TC_ARCH_SUFFIX),$(ARCH_SUFFIX)),
# and a native package leaves ARCH_SUFFIX at -native. Declare the real (arch, DSM) here,
# before common.mk reads it, so TC_OVERLAY_GCC and everything built on it resolve.
TC_ARCH_SUFFIX ?= -$(TC_ARCH)-$(TC_VERS)
# tc_vars.mk supplies these on the cross side and is never generated here, yet
# tc-capability.mk's libatomic probe composes the compiler path out of them.
TC_PREFIX   ?= $(TC_TARGET)-
TC_WORK_DIR ?= $(TC_DIR)/work

# Pass 1 of a profile-guided build is instrumented: it never reaches the archive name, which
# is how a finished build is recognised (toolchain-arch below). Set before native-cc.mk,
# whose archive step reads it.
ifneq ($(filter gen,$(PGO_PHASE)),)
ARCHIVE_TARGET = toolchain-pgo-no-archive
endif

include ../../mk/spksrc.native-cc.mk

# ---- One toolchain, then a whole DSM version ------------------------------------------
# TOOLCHAIN_DIST_SHARED (set by a component whose ARCHIVE_NAME carries TOOLCHAIN_DIST_ARCH):
# a generic arch (x64, armv7, aarch64) shares its toolchain, hence its archive, with a real
# arch of the same DSM (dist-arch.mk), and is built AS that arch. arch-x64-7.1 builds
# apollolake-7.1: the file x64-7.1's consumer fetches, from the toolchain it is a copy of.
toolchain_real = $(if $(call is_true,$(TOOLCHAIN_DIST_SHARED)),$(call overlay_dist_arch,$(firstword \
                   $(subst -, ,$(1))),$(lastword $(subst -, ,$(1))))-$(lastword $(subst -, ,$(1))),$(1))

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
_TC_SELF = TC_ARCH=$(TC_ARCH) TC_VERS=$(TC_VERS)

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
	@$(MAKE) --no-print-directory $(_TC_SELF) PGO_PHASE=gen all
	@$(MAKE) --no-print-directory $(_TC_SELF) PGO_PHASE=gen $(TOOLCHAIN_PGO_TRAIN)
	@$(MSG) "===== $(PKG_NAME)-$(PKG_VERS): $(TC_ARCH)-$(TC_VERS) -- PGO pass 2/2 (optimised) ====="
	@rm -rf $(WORK_DIR)
	@$(MAKE) --no-print-directory $(_TC_SELF) PGO_PHASE=use all
	@rm -rf $(TOOLCHAIN_PGO_DIR)
else
	@$(MAKE) --no-print-directory $(_TC_SELF) all
endif
	@$(MAKE) --no-print-directory $(_TC_SELF) build-archive
endif

.PHONY: toolchain-pgo-no-archive
toolchain-pgo-no-archive:
	@$(MSG) "*** PGO: instrumented build, not archived"

# The training input, generated per arch: three parallel builds sharing one directory
# clobbered one another.
.PHONY: toolchain-pgo-sources
toolchain-pgo-sources:
	@sh $(BASEDIR)/mk/spksrc.native/toolchain-pgo-sources.sh $(TOOLCHAIN_PGO_SOURCES)

# The toolchains a component is built for are its consumers (TOOLCHAIN_CONSUMER), each
# brought back to the arch it builds as (toolchain_real above), once: x64-6.2.4 and
# x86-6.2.4 are one build of x86-6.2.4, x64-7.1 is apollolake-7.1. An arch whose archive
# exists is skipped (toolchain-arch), so a batch resumes where it stopped.
#
# TOOLCHAIN_KEEP_WORK = 0 drops each work dir once its archive exists; a failed one is
# kept, so a broken arch stays debuggable.
#
# Concurrency via xargs -P, deliberately NOT make's -j: -j goes into MAKEFLAGS and
# propagates into every sub-make, parallelising toolchain targets not written for it.
TOOLCHAIN_JOBS      ?= 1
TOOLCHAIN_KEEP_WORK ?= 1

toolchain_archs = $(sort $(foreach d,$(wildcard $(BASEDIR)/overlay/syno-*-$(1)_$(TOOLCHAIN_CONSUMER)),\
                    $(patsubst %-$(1),%,$(call toolchain_real,$(patsubst syno-%,%,$(firstword $(subst _, ,$(notdir $(d)))))))))

.PHONY: all-%
all-%:
	@$(eval _TC_ARCHS := $(call toolchain_archs,$*))
	@$(MSG) "===== $(PKG_NAME)-$(PKG_VERS): all-$* -- $(words $(_TC_ARCHS)) archs, $(TOOLCHAIN_JOBS) at a time ====="
	@echo "$(_TC_ARCHS)" | tr ' ' '\n' | \
	   xargs -P $(TOOLCHAIN_JOBS) -I@ sh -c '$(MAKE) --no-print-directory arch-@-$* && \
	     { $(if $(call is_true,$(TOOLCHAIN_KEEP_WORK)),true,rm -rf work-@-$*) ; }'
	@$(MSG) "===== $(PKG_NAME)-$(PKG_VERS): all-$* complete ====="
