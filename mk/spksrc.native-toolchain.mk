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
# fields (TC_TARGET / TC_GCC / TC_GLIBC), the per-arch work dir, and tc-extract.
# The component-specific logic (config, build/install targets, archive vars) lives
# in mk/spksrc.native/toolchain-$(NATIVE_TOOLCHAIN).mk, included below; the front-
# end include of spksrc.native-cc.mk follows it so that specific file can set the
# CONFIGURE/COMPILE/INSTALL targets before native-cc.mk wires them.
#
# Provides to the component mk and the package:
#   TC_DIR       toolchain/syno-<arch>-<vers>
#   _tc_get      $(call _tc_get,VAR) -> VAR as declared in the toolchain Makefile
#   TC_TARGET    target triple            TC_GCC / TC_GLIBC  toolchain gcc/glibc
#   tc-extract   ensures the gcc toolchain (hence its sysroot) is extracted
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

# Per-(arch,dsm) work dir, cross-style; pre-set so native-cc.mk keeps it (the
# native default would be -native).
WORK_DIR       = $(CURDIR)/work-$(TC_ARCH)-$(TC_VERS)
INSTALL_PREFIX = /usr/local

# The target gcc toolchain must be extracted before its sysroot exists: native
# packages do not bootstrap the toolchain the way cross packages do (cross-stage1).
# Idempotent; a component's PRE_CONFIGURE_TARGET depends on it.
.PHONY: tc-extract
tc-extract:
	@$(MSG) "native-toolchain: ensuring $(TC) is extracted ($(TC_ARCH)-$(TC_VERS))"
	@# NATIVE_TOOLCHAIN_EXTRACT=1 tells the toolchain to skip any component consumer
	@# DEPENDS (e.g. its rust .txz) -- we only need the gcc toolchain + sysroot here,
	@# and that consumer may be the very archive this producer is about to build.
	@$(MAKE) --no-print-directory -C ../../toolchain/$(TC) NATIVE_TOOLCHAIN_EXTRACT=1 toolchain

# Component-specific logic (config, build/install targets, archive vars).
include ../../mk/spksrc.native/toolchain-$(NATIVE_TOOLCHAIN).mk

include ../../mk/spksrc.native-cc.mk
