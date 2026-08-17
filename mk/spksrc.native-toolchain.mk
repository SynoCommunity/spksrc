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

# Install the target toolchain, overlays included -- exactly what a cross package gets. A
# producer needs more than the vendor gcc (a rustc built ON a gcc overlay needs that overlay).
# Idempotent and cookie-guarded; a component's PRE_CONFIGURE_TARGET depends on it.
#
# Caveat: an arch whose rust consumer pins a rev that was never published cannot resolve its
# DEPENDS, so its very first archive must be produced with that consumer dir moved aside.
.PHONY: tc-install
tc-install:
	@$(MSG) "native-toolchain: ensuring $(TC) is installed ($(TC_ARCH)-$(TC_VERS))"
	@$(MAKE) --no-print-directory -C ../../toolchain/$(TC) toolchain

# Component-specific logic (config, build/install targets, archive vars), when the
# component needs any -- a component that only sets vars provided above (e.g. binutils,
# which just uses TC_SYSROOT_DIR) needs no file here.
_TC_COMPONENT_MK := ../../mk/spksrc.native/toolchain-$(NATIVE_TOOLCHAIN).mk
ifneq ($(wildcard $(_TC_COMPONENT_MK)),)
include $(_TC_COMPONENT_MK)
endif

include ../../mk/spksrc.native-cc.mk
