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
#   AVAILABLE  does this (arch, DSM) ship a consumer dir?   _OVERLAY_<c>_DIR
#   REQUESTED  did the caller ask for it?                   OVERLAY_<c>
#   ACTIVE     both of the above                            _OVERLAY_<c>_ON
#
# Variables by role -- <c> is RUSTC, BINUTILS or GCC:
#
#   contract  _OVERLAY_<c>_DIR        consumer dir, empty when the arch ships none
#             OVERLAY_<c>             the switch (local.mk / environment / command line)
#             OVERLAY_<c>_VERSION     which build of it to select, the newest by default
#             _OVERLAY_<c>_ON         requested AND available
#             OVERLAY_BINUTILS_ASKED  OVERLAY_BINUTILS as the first make was given it,
#                                     carried to every sub-make: 0 is refused beside gcc
#
#   degraded  OVERLAY_BINUTILS_MISSING      wanted, arch ships none
#             OVERLAY_BINUTILS_UNMATCHED    active beside the vendor gcc
#             OVERLAY_GCC_NO_BINUTILS       wanted, but no binutils overlay to drive
#             OVERLAY_RUSTC_GCC_FALLBACK    the vendor-gcc rust taken for the gcc overlay
#             OVERLAY_<c>_VERSION_MISSING   ships one, but not that version
#             OVERLAY_WARN_<c>_<state>      the matching banner text
#
#   refused   OVERLAY_BINUTILS_REFUSED      OVERLAY_BINUTILS=0 asked beside an active gcc
#
#   shared    TC_OVERLAY_ALL                every overlay dir of the arch, installed with it
#             RUST_LINK_VIA_BINUTILS        the Rust link through the binutils overlay ld
#             overlay_binutils_version      $(call ...,<vendor>): the as/ld version in use
#             overlay_warn                  $(call ...,<C>,<states>): the banner to print
#
#   created by OVERLAY_COMPONENT_TEMPLATE, for every <c> -- no assignment to search for:
#             _OVERLAY_<c>_ANY, OVERLAY_<c>_VERSION_MISSING and its OVERLAY_WARN_<c>_...;
#             OVERLAY_<c>_VERSION and _OVERLAY_<c>_DIR too, but for RUSTC (rustc.mk)
#
#   internal  _OVERLAY_TC                the toolchain dir name
#             _OVERLAY_<c>_ANY           any version, ignoring OVERLAY_<c>_VERSION
#             _OVERLAY_BINUTILS_WANTED   global overlay, the narrow rust link, or a
#                                        gcc overlay (which has no as/ld of its own)
#             _OVERLAY_BINUTILS_PKG_VERS the global overlay's PKG_VERS, when it is on
#             _OVERLAY_RUSTC_*           the rust candidates, by version and gcc variant
#
# One file per component under spksrc.common/overlay/, read in a fixed order: the
# switches and versions first, which every component reads; then binutils, gcc and rustc;
# then what spans them. An immediate (:=) value only needs what comes before it, and a lazy
# (=) one is read once all are in -- so _OVERLAY_BINUTILS_ON may test _OVERLAY_GCC_ON, and
# the rust pool OVERLAY_GCC.
#
#   binutils.mk  gcc.mk  rustc.mk   AVAILABLE, ACTIVE and the degraded states of each
#   warnings.mk                     the banner text for those states
#
# Warnings are TEXT here; the targets printing them live in
# spksrc.toolchain/overlay/<c>.mk, since a recipe needs a build context and this
# file is read by every package. Component plumbing (shim paths, the tc_vars
# emission) stays there too.
###############################################################################

# The toolchain dir under scrutiny. Both suffixes resolve before spksrc.common.mk is
# included, and both go through TC_NAME's lastword -- TC_ARCH would be a whole arch list.
_OVERLAY_TC := syno$(or $(TC_ARCH_SUFFIX),$(ARCH_SUFFIX))

# ---- REQUESTED (versions) ----------------------------------------------------------
# OVERLAY_<C>_VERSION picks between two builds of a component, side by side, in the
# directory-name form (…_rust-1.82_gcc-4.9.3), not the consumer's PKG_VERS (1.82.0). None
# is pinned: each defaults to the newest the arch ships, unless the caller sets one --
# binutils and gcc in OVERLAY_COMPONENT_TEMPLATE, rust in rustc.mk, among the builds made
# with the selected gcc.

# ---- REQUESTED (switches) ----------------------------------------------------------
# OVERLAY_RUSTC          custom from-source rustc + synology triple; 0 is diagnostic only,
#                        these archs ship an overlay because the stock std does not fit.
# OVERLAY_BINUTILS       GLOBAL: overlay as/ld for EVERY compile. Needs a matched modern
#                        gcc, hence off by default -- OVERLAY_GCC is what matches it, and
#                        turns it on (_OVERLAY_BINUTILS_ON); asking 0 alongside an active
#                        gcc overlay stops the build (OVERLAY_BINUTILS_REFUSED).
# OVERLAY_GCC            a modern gcc beside the vendor one, selected by version suffix;
#                        inert where the arch ships none.
#
# Defaulted here, before the components: the rust pool and _OVERLAY_RUSTC_DIR (rustc.mk) are
# immediate (:=) and read OVERLAY_GCC, so a `?=` after them would leave them seeing an
# unset switch while everything later sees the default.
OVERLAY_RUSTC    ?= 1
OVERLAY_BINUTILS ?= 0
# Off by default, tree-wide: packages keep the vendor gcc, and the producer of a rust
# built with the gcc overlay turns it on for itself (native/rustc-1.98). Tree-wide because a
# package that selects a meta on TC_GCC must agree with the meta spk-meta-source builds,
# and FWRD_ARGS_SPK does not carry the switch. OVERLAY_BINUTILS follows through
# _OVERLAY_BINUTILS_ON: gcc 8.5 needs its assembler.
OVERLAY_GCC      ?= 0
# A typo must not read as "off": anything neither true nor false (macros.mk) stops here.
$(foreach v,OVERLAY_RUSTC OVERLAY_BINUTILS OVERLAY_GCC,$(call assert_bool,$($(v)),$(v)))

_OVERLAY_MK_DIR := $(dir $(lastword $(MAKEFILE_LIST)))overlay

# ---- The names every component shares ----------------------------------------------
# $(eval $(call OVERLAY_COMPONENT_TEMPLATE,<C>,<dir>[,select])), first thing in each
# component file, <C> its upper-case name and <dir> its overlay directory name. Creates:
#
#   _OVERLAY_<C>_ANY                  every <dir> dir the arch ships, any version
#   OVERLAY_<C>_VERSION               the newest of them, unless already set
#   _OVERLAY_<C>_DIR                  the one of OVERLAY_<C>_VERSION
#   OVERLAY_<C>_VERSION_MISSING       ships one, but not that version
#   OVERLAY_WARN_<C>_VERSION_MISSING  the banner for it (warnings.mk)
#
# select: the component picks its version and directory itself (rustc: by gcc variant), so
# OVERLAY_<C>_VERSION and _OVERLAY_<C>_DIR are left to it. The same state carries the same
# name in every component. What differs -- ACTIVE, and
# the states only one of them has -- stays in its own file.
define OVERLAY_COMPONENT_TEMPLATE
_OVERLAY_$(1)_ANY := $$(wildcard $$(BASEDIR)/overlay/$$(_OVERLAY_TC)_$(2)-*)
ifeq ($(3)$$(origin OVERLAY_$(1)_VERSION),undefined)
OVERLAY_$(1)_VERSION := $$(call _overlay_newest,$$(patsubst $$(_OVERLAY_TC)_$(2)-%,%,$$(notdir $$(_OVERLAY_$(1)_ANY))))
_OVERLAY_$(1)_VERSION_DEFAULTED := 1
endif
$(if $(3),,_OVERLAY_$(1)_DIR := $$(wildcard $$(BASEDIR)/overlay/$$(_OVERLAY_TC)_$(2)-$$(OVERLAY_$(1)_VERSION)))
OVERLAY_$(1)_VERSION_MISSING = $$(if $$(_OVERLAY_$(1)_ANY),$$(if $$(strip $$(_OVERLAY_$(1)_DIR)),,1))
OVERLAY_WARN_$(1)_VERSION_MISSING = $$(call overlay_warn_version_missing,$(2),OVERLAY_$(1)_VERSION,$$(OVERLAY_$(1)_VERSION),$$(_OVERLAY_$(1)_ANY))
endef

# The newest of a list of versions; sorting forks a shell, so only when there are two.
_overlay_newest = $(if $(word 2,$(1)),$(firstword $(shell printf '%s\n' $(1) | sort -Vr)),$(1))

include $(_OVERLAY_MK_DIR)/binutils.mk
include $(_OVERLAY_MK_DIR)/gcc.mk
include $(_OVERLAY_MK_DIR)/rustc.mk

# Every overlay of the arch, installed and cleaned with its base toolchain whether a build
# uses it or not. binutils first: the gcc overlay links its as/ld at install time.
TC_OVERLAY_ALL := $(_OVERLAY_BINUTILS_ANY) $(_OVERLAY_GCC_ANY) $(_OVERLAY_RUSTC_ENABLED)

# The as/ld version the binutils overlay supplies to every compile -- asked for, or brought
# by the gcc overlay -- as the consumer's own PKG_VERS: what tc-capability.mk reports for
# TC_BINUTILS, so a MIN_BINUTILS_VERSION floor measures the linker the compile will really
# use rather than the vendor one it replaces. Empty when neither, or the arch has none.
# Here, once the gcc overlay is known.
#
# Immediate: settled here, before stage0.mk includes the work dir's tc_vars.mk.
_OVERLAY_BINUTILS_PKG_VERS := $(if $(or $(call is_true,$(OVERLAY_BINUTILS)),$(_OVERLAY_GCC_ON)),$(call read_makefile_var,$(firstword $(_OVERLAY_BINUTILS_DIR))/Makefile,PKG_VERS))

# The effective as/ld version, given the vendor one to fall back to. Two callers, because
# TC_BINUTILS reaches them from different places: tc-capability.mk reads it out of the
# toolchain's Makefile for a package, while a toolchain declares its own and
# spksrc.toolchain/tc_vars.mk emits it. One macro so they cannot drift apart.
overlay_binutils_version = $(or $(strip $(_OVERLAY_BINUTILS_PKG_VERS)),$(strip $(1)))

# The switches, and what the first make was asked (OVERLAY_BINUTILS_ASKED, binutils.mk),
# on the command line of every sub-make that resolves a toolchain WITHIN this package:
# FWRD_ARGS, which spksrc.common.mk builds from FWRD_VARS. Deliberately absent from
# FWRD_ARGS_SPK: which compiler a package builds with belongs to that package and its own
# work dir, so an spk built as another's meta decides for itself rather than inheriting its
# caller's choice. Not RUST_LINK_VIA_BINUTILS: it derives from _OVERLAY_RUSTC_DIR, which the
# child reads itself.
FWRD_VARS += OVERLAY_RUSTC OVERLAY_BINUTILS OVERLAY_GCC OVERLAY_BINUTILS_ASKED

# The only way the versions travel: objects from gcc 4.3.7 will not mix with gcc 8.5 C++,
# so a choice must hold tree-wide -- the first make's, newest or set, in every sub-make.
#
# Exported ONLY once it has a value. A version is derived from the dirs this arch ships,
# and there are contexts where that list is legitimately empty -- a toolchain consumer
# directory resolves _OVERLAY_TC to syno-native, which owns no overlay. Exporting it there
# would put an EMPTY value in the environment of every sub-make, which `?=` and the
# origin test cannot override: the child would inherit "no version" and disable its own
# overlay. `export` alone creates that empty value, so the guard is on the export.
$(foreach c,BINUTILS GCC RUSTC,$(if $(strip $(OVERLAY_$(c)_VERSION)),$(eval export OVERLAY_$(c)_VERSION)))

# The switches are exported too, for what FWRD_ARGS cannot reach. The two are not
# redundant:
#   FWRD_ARGS  a command-line variable, so it outranks an `OVERLAY_x = ...` in a dependency's
#              Makefile -- one compiler across the tree. An exported value would lose there.
#   export     the sub-makes started with MAKEFLAGS= and no FWRD_ARGS (wheels, crossenv,
#              publish): a command-line switch is gone from MAKEFLAGS there, and only the
#              environment still carries it to the wheels of the same package.
export OVERLAY_RUSTC OVERLAY_BINUTILS OVERLAY_GCC OVERLAY_BINUTILS_ASKED

# ---- Degraded states ---------------------------------------------------------------
# Each component defines its own (<c>_MISSING, <c>_VERSION_MISSING, ...); overlay_warn
# prints the first of a component's list, so their order there is their priority.
include $(_OVERLAY_MK_DIR)/warnings.mk

# Once every component is in: the refusal reads _OVERLAY_GCC_ON.
ifneq ($(OVERLAY_BINUTILS_REFUSED),)
$(info ===>  *********************************************************************)
$(info ===>  *** OVERLAY_BINUTILS=$(OVERLAY_BINUTILS_ASKED) cannot be honoured for [$(_OVERLAY_TC)]:)
$(info ===>  *** the gcc $(OVERLAY_GCC_VERSION) overlay is active, and drives as/ld through)
$(info ===>  *** binutils $(OVERLAY_BINUTILS_VERSION) -- the vendor ones cannot assemble what it emits.)
$(info ===>  *** For the vendor as/ld, set OVERLAY_GCC=0 as well.)
$(info ===>  *********************************************************************)
$(error OVERLAY_BINUTILS=$(OVERLAY_BINUTILS_ASKED) and the gcc overlay cannot be used together)
endif
