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
# A request that cannot be honored degrades to the stock tools and is WARNED
# about (the warning targets live in spksrc.toolchain/overlay-<c>.mk, since a
# recipe needs a build context and this file is read by every package).
#
# Only decisions belong here. Component plumbing -- shim paths, the linker
# wrapper, tc_vars emission -- stays in spksrc.toolchain/overlay-<c>.mk.
###############################################################################

# The toolchain dir under scrutiny. Both suffixes resolve before spksrc.common.mk is
# included -- TC_ARCH_SUFFIX in spksrc.toolchain.mk, ARCH_SUFFIX in spksrc.cross-cc.mk --
# and both go through TC_NAME's lastword, so a multi-arch toolchain yields one name
# (TC_ARCH would be its whole arch list).
_OVERLAY_TC := syno$(or $(TC_ARCH_SUFFIX),$(ARCH_SUFFIX))

# ---- REQUESTED (versions): which build of each component to look for ---------------
# The directory-name form (syno-<arch>-<dsm>_rust-1.82_gcc-4.9.3), not the consumer's
# PKG_VERS (1.82.0). A second build of the same component -- e.g. a rustc rebuilt against a
# gcc overlay -- lands beside the first, and this picks between them.
OVERLAY_RUSTC_VERS     ?= 1.82
OVERLAY_BINUTILS_VERS  ?= 2.30

# ---- AVAILABLE: the per-arch consumer dir, empty when the arch ships none ----------
# Non-empty doubles as the path to it. Legacy archs ship both, standard archs neither.
# _ANY ignores the requested version: it separates "this arch has no overlay at all"
# (a standard arch -- normal) from "it has one, but not the version asked for" (a
# mis-set knob -- worth a warning, see MISSING below).
_OVERLAY_RUSTC_ANY    := $(wildcard $(BASEDIR)/toolchain/$(_OVERLAY_TC)_rust-*)
_OVERLAY_BINUTILS_ANY := $(wildcard $(BASEDIR)/toolchain/$(_OVERLAY_TC)_binutils-*)
TC_OVERLAY_RUSTC      := $(wildcard $(BASEDIR)/toolchain/$(_OVERLAY_TC)_rust-$(OVERLAY_RUSTC_VERS)_gcc-*)
TC_OVERLAY_BINUTILS   := $(wildcard $(BASEDIR)/toolchain/$(_OVERLAY_TC)_binutils-$(OVERLAY_BINUTILS_VERS)_gcc-*)

# ---- REQUESTED: the switches, defaulted once for both sides ------------------------
# OVERLAY_RUSTC          custom from-source rustc + synology triple. ON where available;
#                        0 falls back to stock rustup (diagnostic only -- the archs that
#                        ship an overlay do so because the stock std does not fit them).
# OVERLAY_BINUTILS       GLOBAL: overlay as/ld for EVERY compile. Valid only under a
#                        MATCHED modern gcc, so OFF by default.
# RUST_LINK_VIA_BINUTILS NARROW: only the Rust link takes the overlay ld; C keeps the
#                        vendor as/ld. ON wherever a custom rustc is in play.
OVERLAY_RUSTC          ?= 1
OVERLAY_BINUTILS       ?= 0
RUST_LINK_VIA_BINUTILS ?= $(if $(strip $(TC_OVERLAY_RUSTC)),1)

# ---- ACTIVE: requested AND available ------------------------------------------------
# Lazy (=) on purpose: local.mk is read AFTER this file, so a switch set there must still
# be picked up. The wildcards above stay immediate -- the filesystem does not move.
OVERLAY_RUSTC_ON     = $(if $(strip $(TC_OVERLAY_RUSTC)),$(if $(filter 1 on ON,$(strip $(OVERLAY_RUSTC))),1))
OVERLAY_BINUTILS_ON  = $(if $(strip $(TC_OVERLAY_BINUTILS)),$(if $(filter 1 on ON,$(strip $(OVERLAY_BINUTILS))),1))

# Either use pulls the same downloaded binutils; they differ only in scope.
_OVERLAY_BINUTILS_WANTED    = $(if $(filter 1 on ON,$(strip $(OVERLAY_BINUTILS)))$(filter 1,$(strip $(RUST_LINK_VIA_BINUTILS))),1)
OVERLAY_BINUTILS_PROVISION  = $(if $(strip $(TC_OVERLAY_BINUTILS)),$(_OVERLAY_BINUTILS_WANTED))

# ---- Tool selection, shared by every generator --------------------------------------
# A shell fragment, not a $(call): the generators loop over $(TOOLS) and resolve $${source}
# at recipe time. Sets $${bindir} for the current tool -- only as/ld move to the overlay;
# gcc/ar/nm/... always stay the vendor's. Used by the autotools, cmake and meson emitters
# so the three cannot drift apart (they did: cmake and meson kept the vendor ld).
_OVERLAY_TOOL_BINDIR = bindir="$(TC_WORK_DIR)/$(TC_TARGET)/bin" ; \
	case "$${source}" in ld|as) [ -n "$(OVERLAY_BINUTILS_ON)" ] && bindir="$(OVERLAY_BINUTILS_BIN)" ;; esac

# ---- Degraded / risky states, and what to say about them ----------------------------
# MISSING    asked for a binutils overlay this arch does not ship -> stock as/ld instead.
# UNMATCHED  global overlay ON: modern as/ld driving the VENDOR gcc. No gcc overlay exists
#            yet, so it is unmatched by construction -- revisit once native/gcc8 lands.
OVERLAY_BINUTILS_MISSING    = $(if $(strip $(TC_OVERLAY_BINUTILS)),,$(_OVERLAY_BINUTILS_WANTED))
OVERLAY_BINUTILS_UNMATCHED  = $(OVERLAY_BINUTILS_ON)

# VERSMISS  the arch DOES ship this component, but not the version asked for -- a mis-set
#           OVERLAY_<c>_VERS, which would otherwise disable the overlay silently. Distinct
#           from a standard arch, where shipping none is the normal case.
OVERLAY_RUSTC_VERSMISS      = $(if $(_OVERLAY_RUSTC_ANY),$(if $(strip $(TC_OVERLAY_RUSTC)),,1))
OVERLAY_BINUTILS_VERSMISS   = $(if $(_OVERLAY_BINUTILS_ANY),$(if $(strip $(TC_OVERLAY_BINUTILS)),,1))

# The wording lives with the condition it describes; a define is inert, so it costs the ~500
# packages that read this file nothing. Emitted from a RECIPE (spksrc.toolchain/overlay-*.mk):
# a toolchain Makefile is re-parsed several times per build, so $(warning) would repeat.
# Banner style follows spksrc.spk-meta/base.mk.
define OVERLAY_WARN_BINUTILS_MISSING
$(MSG) "*********************************************************************" ; \
$(MSG) "*** No binutils overlay available for [$(_OVERLAY_TC)]" ; \
$(MSG) "*** Falling back to this toolchain's own as/ld" ; \
$(MSG) "*********************************************************************"
endef

# $(1) component label, $(2) knob name, $(3) requested version, $(4) dirs the arch ships.
define overlay_warn_versmiss
$(MSG) "*********************************************************************" ; \
$(MSG) "*** No $(1) overlay $(3) for [$(_OVERLAY_TC)]" ; \
$(MSG) "*** Available: $(patsubst $(_OVERLAY_TC)_%,%,$(notdir $(4)))" ; \
$(MSG) "*** Overlay disabled -- set $(2) to one of the above" ; \
$(MSG) "*********************************************************************"
endef

OVERLAY_WARN_RUSTC_VERSMISS    = $(call overlay_warn_versmiss,rust,OVERLAY_RUSTC_VERS,$(OVERLAY_RUSTC_VERS),$(_OVERLAY_RUSTC_ANY))
OVERLAY_WARN_BINUTILS_VERSMISS = $(call overlay_warn_versmiss,binutils,OVERLAY_BINUTILS_VERS,$(OVERLAY_BINUTILS_VERS),$(_OVERLAY_BINUTILS_ANY))

define OVERLAY_WARN_BINUTILS_UNMATCHED
$(MSG) "*********************************************************************" ; \
$(MSG) "*** OVERLAY_BINUTILS=1: every compile uses binutils $(OVERLAY_BINUTILS_VERS) as/ld" ; \
$(MSG) "*** paired with the vendor gcc $(TC_GCC), which it is not matched to." ; \
$(MSG) "*** This can cause build failures or non-functional binaries." ; \
$(MSG) "*********************************************************************"
endef
