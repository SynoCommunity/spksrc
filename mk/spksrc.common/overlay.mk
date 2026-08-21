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
# Variables by role -- <c> is RUSTC, BINUTILS or GCC:
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
#             _OVERLAY_BINUTILS_WANTED   global overlay, the narrow rust link, or a
#                                        gcc overlay (which has no as/ld of its own)
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
OVERLAY_GCC_VERS       ?= 8.5

# ---- AVAILABLE ---------------------------------------------------------------------
# Non-empty doubles as the path. _ANY ignores the requested version, which is what tells
# "this arch has no overlay" (standard arch) from "not that version" (mis-set knob).
_OVERLAY_RUSTC_ANY    := $(wildcard $(BASEDIR)/toolchain/$(_OVERLAY_TC)_rust-*)
_OVERLAY_BINUTILS_ANY := $(wildcard $(BASEDIR)/toolchain/$(_OVERLAY_TC)_binutils-*)
_OVERLAY_GCC_ANY      := $(wildcard $(BASEDIR)/toolchain/$(_OVERLAY_TC)_gcc-*)
TC_OVERLAY_RUSTC      := $(wildcard $(BASEDIR)/toolchain/$(_OVERLAY_TC)_rust-$(OVERLAY_RUSTC_VERS)_gcc-*)
TC_OVERLAY_BINUTILS   := $(wildcard $(BASEDIR)/toolchain/$(_OVERLAY_TC)_binutils-$(OVERLAY_BINUTILS_VERS)_gcc-*)
TC_OVERLAY_GCC        := $(wildcard $(BASEDIR)/toolchain/$(_OVERLAY_TC)_gcc-$(OVERLAY_GCC_VERS)_gcc-*)

# ---- REQUESTED (switches) ----------------------------------------------------------
# OVERLAY_RUSTC          custom from-source rustc + synology triple; 0 is diagnostic only,
#                        these archs ship an overlay because the stock std does not fit.
# OVERLAY_BINUTILS       GLOBAL: overlay as/ld for EVERY compile. Needs a matched modern
#                        gcc, hence off by default -- OVERLAY_GCC is what matches it.
# RUST_LINK_VIA_BINUTILS NARROW: only the Rust link takes the overlay ld; C keeps the vendor's.
# OVERLAY_GCC            a modern gcc beside the vendor one, selected by version suffix.
#                        Off by default: installing one must not silently move any
#                        existing package onto a different compiler.
#
# Was binutils REFUSED, or merely left at a default? Only the command line and the
# environment express a refusal -- local.mk holds a ?= default like this file, so "file"
# cannot tell the two apart. This decides between forcing binutils on for gcc and warning
# that the pair was broken on purpose.
#
# Ignore a forwarded set: OVERLAY_SELECTORS re-emits these on the sub-make command line,
# which would turn local.mk's default into an apparent refusal in every dependency. The
# top-level make is the one that sees the real command line, and warns once.
_OVERLAY_BINUTILS_ASKED := $(if $(_OVERLAY_FORWARDED),,$(if $(findstring command,$(origin OVERLAY_BINUTILS))$(findstring environment,$(origin OVERLAY_BINUTILS)),1))
OVERLAY_RUSTC          ?= 1
OVERLAY_BINUTILS       ?= 0
OVERLAY_GCC            ?= 0
RUST_LINK_VIA_BINUTILS ?= $(if $(strip $(TC_OVERLAY_RUSTC)),1)

# What a build hands to everything below it. A compiler or linker choice has to hold for a
# package AND its whole dependency tree: ffmpeg8 on gcc 8.5 cannot link pcre built on gcc
# 4.3.7 -- the C++11 ABI differs. Passed on the sub-make command line by depend.mk, which
# also puts it in MAKEFLAGS, so it reaches the whole tree from wherever the build started.
# Command line beats the dependency's own default, which is the point: one tree, one
# compiler. spksrc.cross-cc.mk forwards the same set to the tcvars generation.
OVERLAY_SELECTORS = OVERLAY_RUSTC=$(OVERLAY_RUSTC) OVERLAY_BINUTILS=$(OVERLAY_BINUTILS) OVERLAY_GCC=$(OVERLAY_GCC) _OVERLAY_FORWARDED=1

# ---- ACTIVE ------------------------------------------------------------------------
# Lazy (=): local.mk is read before this file, but a switch may also arrive from the
# environment or the command line. The wildcards above stay immediate.
OVERLAY_RUSTC_ON     = $(if $(strip $(TC_OVERLAY_RUSTC)),$(if $(filter 1 on ON,$(strip $(OVERLAY_RUSTC))),1))
# A gcc overlay turns this on unconditionally: gcc reaches as/ld only through
# OVERLAY_BINUTILS_FLAG, so the pair is ONE decision. There is deliberately no way to
# refuse it -- gcc 8.5 on the vendor as/ld cannot assemble what it emits, so obeying such
# a request would only buy a confusing failure later. A package therefore activates
# OVERLAY_GCC alone. No cycle: OVERLAY_GCC_ON tests availability, not this.
OVERLAY_BINUTILS_ON  = $(if $(strip $(TC_OVERLAY_BINUTILS)),$(if $(filter 1 on ON,$(strip $(OVERLAY_BINUTILS)))$(OVERLAY_GCC_ON),1))

# gcc asked for, binutils explicitly refused. Unsupported: gcc 8.5 then drives the vendor
# as/ld, which cannot assemble what it emits.
# Overridden rather than obeyed: say so instead of flipping it in silence.
OVERLAY_BINUTILS_FORCED = $(if $(_OVERLAY_BINUTILS_ASKED),$(if $(OVERLAY_GCC_ON),$(if $(filter 1 on ON,$(strip $(OVERLAY_BINUTILS))),,1)))
# GCC additionally requires binutils to be available: it drives as/ld through -B into that
# overlay's shim, and the vendor ones cannot assemble what a modern gcc emits.
OVERLAY_GCC_ON       = $(if $(strip $(TC_OVERLAY_GCC)),$(if $(strip $(TC_OVERLAY_BINUTILS)),$(if $(filter 1 on ON,$(strip $(OVERLAY_GCC))),1)))

# All three uses pull the same archive; they differ only in scope. The gcc overlay ships
# no as/ld of its own, so without this it would silently drive the vendor ones.
_OVERLAY_BINUTILS_WANTED    = $(if $(filter 1 on ON,$(strip $(OVERLAY_BINUTILS)))$(filter 1,$(strip $(RUST_LINK_VIA_BINUTILS)))$(filter 1 on ON,$(strip $(OVERLAY_GCC))),1)
OVERLAY_BINUTILS_PROVISION  = $(if $(strip $(TC_OVERLAY_BINUTILS)),$(_OVERLAY_BINUTILS_WANTED))

# ---- Degraded states, and what to say about them ------------------------------------
# Disjoint by construction, so the order they are reported in carries no meaning. There is
# no UNMATCHED: "global overlay as/ld on a gcc it is not matched to" is exactly
# OVERLAY_BINUTILS_ON without OVERLAY_GCC_ON, so the target tests that pair.
OVERLAY_BINUTILS_MISSING         = $(if $(_OVERLAY_BINUTILS_ANY),,$(_OVERLAY_BINUTILS_WANTED))
OVERLAY_RUSTC_VERSION_MISSING    = $(if $(_OVERLAY_RUSTC_ANY),$(if $(strip $(TC_OVERLAY_RUSTC)),,1))
OVERLAY_BINUTILS_VERSION_MISSING = $(if $(_OVERLAY_BINUTILS_ANY),$(if $(strip $(TC_OVERLAY_BINUTILS)),,1))
OVERLAY_GCC_VERSION_MISSING      = $(if $(_OVERLAY_GCC_ANY),$(if $(strip $(TC_OVERLAY_GCC)),,1))
OVERLAY_GCC_NO_BINUTILS          = $(if $(strip $(TC_OVERLAY_GCC)),$(if $(strip $(TC_OVERLAY_BINUTILS)),,$(if $(filter 1 on ON,$(strip $(OVERLAY_GCC))),1)))

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
OVERLAY_WARN_GCC_VERSION_MISSING      = $(call overlay_warn_version_missing,gcc,OVERLAY_GCC_VERS,$(OVERLAY_GCC_VERS),$(_OVERLAY_GCC_ANY))

define OVERLAY_WARN_BINUTILS_UNMATCHED
$(MSG) "*********************************************************************" ; \
$(MSG) "*** OVERLAY_BINUTILS=1: every compile uses binutils $(OVERLAY_BINUTILS_VERS) as/ld" ; \
$(MSG) "*** paired with the vendor gcc $(TC_GCC), which it is not matched to." ; \
$(MSG) "*** Set OVERLAY_GCC=1 to pair it with gcc $(OVERLAY_GCC_VERS) instead." ; \
$(MSG) "*********************************************************************"
endef

define OVERLAY_WARN_BINUTILS_FORCED
$(MSG) "*********************************************************************" ; \
$(MSG) "*** OVERLAY_BINUTILS=0 ignored: OVERLAY_GCC=1 requires binutils $(OVERLAY_BINUTILS_VERS)" ; \
$(MSG) "*** gcc $(OVERLAY_GCC_VERS) drives as/ld through it; the vendor ones" ; \
$(MSG) "*** cannot assemble what it emits. Turn OVERLAY_GCC off for the stock one." ; \
$(MSG) "*********************************************************************"
endef

# The gcc overlay drives as/ld through -B into the binutils shim. Without that shim it
# would reach for the vendor ones -- ld 2.18 on ppc853x -- so say so rather than proceed.
define OVERLAY_WARN_GCC_NO_BINUTILS
$(MSG) "*********************************************************************" ; \
$(MSG) "*** OVERLAY_GCC=1 for [$(_OVERLAY_TC)], but no binutils overlay is active" ; \
$(MSG) "*** gcc $(OVERLAY_GCC_VERS) would fall back to the vendor as/ld ($(TC_GCC) era)" ; \
$(MSG) "*** Overlay disabled -- provide binutils $(OVERLAY_BINUTILS_VERS) for this arch" ; \
$(MSG) "*********************************************************************"
endef
