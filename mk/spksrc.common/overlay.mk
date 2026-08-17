###############################################################################
# spksrc.common/overlay.mk
#
# THE decision point for the OVERLAY_<component> family. Included from
# spksrc.common.mk, so the toolchain side and the package side reach the same
# answers from the same expressions instead of each re-deriving them.
#
# Three questions, kept apart on purpose -- conflating them is what produced
# both of the bugs this file exists to prevent:
#
#   AVAILABLE  does this (arch, DSM) ship a consumer dir?   TC_OVERLAY_<c>
#   REQUESTED  did the caller ask for it?                   OVERLAY_<c>
#   ACTIVE     both of the above                            OVERLAY_<c>_ON
#
# Variables by role -- <c> is RUSTC or BINUTILS:
#
#   contract  TC_OVERLAY_<c>      consumer dir, empty when the arch ships none
#             OVERLAY_<c>         the switch (local.mk / environment / command line)
#             OVERLAY_<c>_VERS    which build of it to select
#             OVERLAY_<c>_ON      requested AND available
#
#   degraded  OVERLAY_BINUTILS_MISSING      wanted, arch ships none
#             OVERLAY_<c>_VERSION_MISSING   ships one, but not that version
#             OVERLAY_BINUTILS_PROVISION    download it (either use needs it)
#             OVERLAY_WARN_*                the matching banner text
#
#   internal  _OVERLAY_TC                the toolchain dir name
#             _OVERLAY_<c>_ANY           any version, ignoring OVERLAY_<c>_VERS
#             _OVERLAY_BINUTILS_WANTED   global overlay or the narrow rust link
#             _OVERLAY_TOOL_BINDIR       shell fragment picking as/ld
#
# Warnings are TEXT here; the targets printing them live in
# spksrc.toolchain/overlay-<c>.mk, since a recipe needs a build context and this
# file is read by every package. Component plumbing (shim paths, the tc_vars
# emission) stays there too.
###############################################################################

# The toolchain dir under scrutiny. Both suffixes resolve before spksrc.common.mk is
# included, and both go through TC_NAME's lastword -- TC_ARCH would be a whole arch list.
_OVERLAY_TC := syno$(or $(TC_ARCH_SUFFIX),$(ARCH_SUFFIX))

# ---- REQUESTED (versions) ----------------------------------------------------------
# The directory-name form (…_rust-1.82_gcc-4.9.3), not the consumer's PKG_VERS (1.82.0).
# A second build of a component lands beside the first; this picks between them.
OVERLAY_RUSTC_VERS     ?= 1.82
OVERLAY_BINUTILS_VERS  ?= 2.30

# ---- AVAILABLE ---------------------------------------------------------------------
# Non-empty doubles as the path. _ANY ignores the requested version, which is what tells
# "this arch has no overlay" (standard arch) from "not that version" (mis-set knob).
_OVERLAY_RUSTC_ANY    := $(wildcard $(BASEDIR)/toolchain/$(_OVERLAY_TC)_rust-*)
_OVERLAY_BINUTILS_ANY := $(wildcard $(BASEDIR)/toolchain/$(_OVERLAY_TC)_binutils-*)
TC_OVERLAY_RUSTC      := $(wildcard $(BASEDIR)/toolchain/$(_OVERLAY_TC)_rust-$(OVERLAY_RUSTC_VERS)_gcc-*)
TC_OVERLAY_BINUTILS   := $(wildcard $(BASEDIR)/toolchain/$(_OVERLAY_TC)_binutils-$(OVERLAY_BINUTILS_VERS)_gcc-*)

# ---- REQUESTED (switches) ----------------------------------------------------------
# OVERLAY_RUSTC          custom from-source rustc + synology triple; 0 is diagnostic only,
#                        these archs ship an overlay because the stock std does not fit.
# OVERLAY_BINUTILS       GLOBAL: overlay as/ld for EVERY compile. Needs a matched modern
#                        gcc, hence off by default.
# RUST_LINK_VIA_BINUTILS NARROW: only the Rust link takes the overlay ld; C keeps the vendor's.
OVERLAY_RUSTC          ?= 1
OVERLAY_BINUTILS       ?= 0
RUST_LINK_VIA_BINUTILS ?= $(if $(strip $(TC_OVERLAY_RUSTC)),1)

# ---- ACTIVE ------------------------------------------------------------------------
# Lazy (=): local.mk is read before this file, but a switch may also arrive from the
# environment or the command line. The wildcards above stay immediate.
OVERLAY_RUSTC_ON     = $(if $(strip $(TC_OVERLAY_RUSTC)),$(if $(filter 1 on ON,$(strip $(OVERLAY_RUSTC))),1))
OVERLAY_BINUTILS_ON  = $(if $(strip $(TC_OVERLAY_BINUTILS)),$(if $(filter 1 on ON,$(strip $(OVERLAY_BINUTILS))),1))

# Both uses pull the same archive; they differ only in scope.
_OVERLAY_BINUTILS_WANTED    = $(if $(filter 1 on ON,$(strip $(OVERLAY_BINUTILS)))$(filter 1,$(strip $(RUST_LINK_VIA_BINUTILS))),1)
OVERLAY_BINUTILS_PROVISION  = $(if $(strip $(TC_OVERLAY_BINUTILS)),$(_OVERLAY_BINUTILS_WANTED))

# ---- Tool selection, shared by every generator --------------------------------------
# A shell fragment, not a $(call): the generators loop over $(TOOLS) and resolve $${source}
# at recipe time. Only as/ld move to the overlay. Shared so the autotools, cmake and meson
# emitters cannot drift apart -- they did.
_OVERLAY_TOOL_BINDIR = bindir="$(TC_WORK_DIR)/$(TC_TARGET)/bin" ; \
	case "$${source}" in ld|as) [ -n "$(OVERLAY_BINUTILS_ON)" ] && bindir="$(OVERLAY_BINUTILS_BIN)" ;; esac

# ---- Degraded states, and what to say about them ------------------------------------
# Disjoint by construction, so the order they are reported in carries no meaning. There is
# no UNMATCHED: "global overlay on a vendor gcc it is not matched to" is exactly
# OVERLAY_BINUTILS_ON while no gcc overlay exists, so the target tests that.
OVERLAY_BINUTILS_MISSING         = $(if $(_OVERLAY_BINUTILS_ANY),,$(_OVERLAY_BINUTILS_WANTED))
OVERLAY_RUSTC_VERSION_MISSING    = $(if $(_OVERLAY_RUSTC_ANY),$(if $(strip $(TC_OVERLAY_RUSTC)),,1))
OVERLAY_BINUTILS_VERSION_MISSING = $(if $(_OVERLAY_BINUTILS_ANY),$(if $(strip $(TC_OVERLAY_BINUTILS)),,1))

# Text only; a define is inert, so it costs the packages reading this file nothing. Emitted
# from a recipe: this file is re-parsed several times per build, so $(warning) would repeat.
# Banner style follows spksrc.spk-meta/base.mk.
define OVERLAY_WARN_BINUTILS_MISSING
$(MSG) "*********************************************************************" ; \
$(MSG) "*** No binutils overlay available for [$(_OVERLAY_TC)]" ; \
$(MSG) "*** Falling back to this toolchain's own as/ld" ; \
$(MSG) "*********************************************************************"
endef

# $(1) component, $(2) knob name, $(3) requested version, $(4) dirs the arch ships.
define overlay_warn_version_missing
$(MSG) "*********************************************************************" ; \
$(MSG) "*** No $(1) overlay $(3) for [$(_OVERLAY_TC)]" ; \
$(MSG) "*** Available: $(patsubst $(_OVERLAY_TC)_%,%,$(notdir $(4)))" ; \
$(MSG) "*** Overlay disabled -- set $(2) to one of the above" ; \
$(MSG) "*********************************************************************"
endef

OVERLAY_WARN_RUSTC_VERSION_MISSING    = $(call overlay_warn_version_missing,rust,OVERLAY_RUSTC_VERS,$(OVERLAY_RUSTC_VERS),$(_OVERLAY_RUSTC_ANY))
OVERLAY_WARN_BINUTILS_VERSION_MISSING = $(call overlay_warn_version_missing,binutils,OVERLAY_BINUTILS_VERS,$(OVERLAY_BINUTILS_VERS),$(_OVERLAY_BINUTILS_ANY))

define OVERLAY_WARN_BINUTILS_UNMATCHED
$(MSG) "*********************************************************************" ; \
$(MSG) "*** OVERLAY_BINUTILS=1: every compile uses binutils $(OVERLAY_BINUTILS_VERS) as/ld" ; \
$(MSG) "*** paired with the vendor gcc $(TC_GCC), which it is not matched to." ; \
$(MSG) "*** This can cause build failures or non-functional binaries." ; \
$(MSG) "*********************************************************************"
endef
