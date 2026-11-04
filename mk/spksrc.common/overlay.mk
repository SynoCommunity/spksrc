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
#             OVERLAY_BINUTILS_UNMATCHED    active beside the vendor gcc
#             OVERLAY_GCC_NO_BINUTILS       wanted, but no binutils overlay to drive
#             OVERLAY_RUSTC_GCC_FALLBACK    the vendor-gcc rust taken for the gcc overlay
#             OVERLAY_<c>_VERSION_MISSING   ships one, but not that version
#             OVERLAY_WARN_<c>_<state>      the matching banner text
#
#   created by OVERLAY_COMPONENT_TEMPLATE, for every <c> -- no assignment to search for:
#             _OVERLAY_<c>_ANY, TC_OVERLAY_<c> (but RUSTC), OVERLAY_<c>_VERSION_MISSING,
#             OVERLAY_WARN_<c>_VERSION_MISSING
#
#   internal  _OVERLAY_TC                the toolchain dir name
#             _OVERLAY_<c>_ANY           any version, ignoring OVERLAY_<c>_VERS
#             _OVERLAY_BINUTILS_WANTED   global overlay, the narrow rust link, or a
#                                        gcc overlay (which has no as/ld of its own)
#
# One file per component under spksrc.common/overlay/, read in a fixed order: the
# switches and versions first, which every component reads; then binutils, gcc and rustc;
# then what spans them. An immediate (:=) value only needs what comes before it, and a lazy
# (=) one is read once all are in -- so OVERLAY_BINUTILS_ON may test OVERLAY_GCC_ON, and
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
# The directory-name form (…_rust-1.82_gcc-4.9.3), not the consumer's PKG_VERS (1.82.0).
# A second build of a component lands beside the first; this picks between them.
OVERLAY_BINUTILS_VERS  ?= 2.30
OVERLAY_GCC_VERS       ?= 8.5
# OVERLAY_RUSTC_VERS is NOT pinned here: it defaults to the newest this arch ships, and
# is computed in rustc.mk because the candidate set depends on OVERLAY_GCC_VERS.

# ---- REQUESTED (switches) ----------------------------------------------------------
# OVERLAY_RUSTC          custom from-source rustc + synology triple; 0 is diagnostic only,
#                        these archs ship an overlay because the stock std does not fit.
# OVERLAY_BINUTILS       GLOBAL: overlay as/ld for EVERY compile. Needs a matched modern
#                        gcc, hence off by default -- OVERLAY_GCC is what matches it, and
#                        turns it on (OVERLAY_BINUTILS_ON); asking 0 alongside an active
#                        gcc overlay stops the build (OVERLAY_BINUTILS_REFUSED).
# OVERLAY_GCC            a modern gcc beside the vendor one, selected by version suffix;
#                        inert where the arch ships none.
#
# REQUESTED, defaulted here rather than further down: _RUSTC_POOL and TC_OVERLAY_RUSTC
# (rustc.mk) are immediate (:=) and read OVERLAY_GCC, so a `?=` after them would leave those
# two seeing an unset switch while everything later sees the default. That was invisible
# while the default was 0 -- unset and 0 read alike -- and mismatches the moment it is 1:
# the gcc overlay asked for, the vendor-gcc rust consumer picked, and stage0 then refuses
# the work dir.
OVERLAY_RUSTC          ?= 1
OVERLAY_BINUTILS       ?= 0
# Off by default, tree-wide: packages keep the vendor gcc, and the producer of a rust
# built with the gcc overlay turns it on for itself (native/rustc-1.98). Tree-wide because a
# package that selects a meta on TC_GCC must agree with the meta spk-meta-source builds,
# and FWRD_ARGS_SPK does not carry the switch. OVERLAY_BINUTILS follows through
# OVERLAY_BINUTILS_ON: gcc 8.5 needs its assembler.
OVERLAY_GCC            ?= 0
# A typo must not read as "off": anything neither true nor false (macros.mk) stops here.
$(foreach v,OVERLAY_RUSTC OVERLAY_BINUTILS OVERLAY_GCC,$(call assert_bool,$($(v)),$(v)))

_OVERLAY_DIR := $(dir $(lastword $(MAKEFILE_LIST)))overlay

# ---- The names every component shares ----------------------------------------------
# $(eval $(call OVERLAY_COMPONENT_TEMPLATE,<C>,<dir>[,select])), first thing in each
# component file, <C> its upper-case name and <dir> its overlay directory name. Creates:
#
#   _OVERLAY_<C>_ANY                  every <dir> dir the arch ships, any version
#   TC_OVERLAY_<C>                    the one of OVERLAY_<C>_VERS -- unless select: the
#                                     component picks it itself (rustc: by gcc variant)
#   OVERLAY_<C>_VERSION_MISSING       ships one, but not that version
#   OVERLAY_WARN_<C>_VERSION_MISSING  the banner for it (warnings.mk)
#
# so the same state carries the same name in every component. What differs -- ACTIVE, and
# the states only one of them has -- stays in its own file.
define OVERLAY_COMPONENT_TEMPLATE
_OVERLAY_$(1)_ANY := $$(wildcard $$(BASEDIR)/overlay/$$(_OVERLAY_TC)_$(2)-*)
$(if $(3),,TC_OVERLAY_$(1) := $$(wildcard $$(BASEDIR)/overlay/$$(_OVERLAY_TC)_$(2)-$$(OVERLAY_$(1)_VERS)))
OVERLAY_$(1)_VERSION_MISSING = $$(if $$(_OVERLAY_$(1)_ANY),$$(if $$(strip $$(TC_OVERLAY_$(1))),,1))
OVERLAY_WARN_$(1)_VERSION_MISSING = $$(call overlay_warn_version_missing,$(2),OVERLAY_$(1)_VERS,$$(OVERLAY_$(1)_VERS),$$(_OVERLAY_$(1)_ANY))
endef

include $(_OVERLAY_DIR)/binutils.mk
include $(_OVERLAY_DIR)/gcc.mk
include $(_OVERLAY_DIR)/rustc.mk

# Every overlay of the arch, installed and cleaned with its base toolchain whether a build
# uses it or not. binutils first: the gcc overlay links its as/ld at install time.
TC_OVERLAY_ALL        := $(_OVERLAY_BINUTILS_ANY) $(_OVERLAY_GCC_ANY) $(_OVERLAY_RUSTC_ENABLED)

# Carried to every sub-make that resolves a toolchain WITHIN this package (FWRD_ARGS).
# Deliberately absent from FWRD_ARGS_SPK: which compiler a package builds with belongs
# to that package and its own work dir, so an spk built as another's meta decides for
# itself rather than inheriting its caller's choice. Not RUST_LINK_VIA_BINUTILS: it
# derives from TC_OVERLAY_RUSTC, which the child reads itself.
FWRD_VARS += OVERLAY_RUSTC OVERLAY_BINUTILS OVERLAY_GCC _OVERLAY_BINUTILS_ASKED

# The only way the _VERS pins travel: objects from gcc 4.3.7 will not mix with gcc 8.5
# C++, so a choice must hold tree-wide. The switches themselves are exported below.
export OVERLAY_BINUTILS_VERS OVERLAY_GCC_VERS

# Exported as well, for what FWRD_ARGS cannot reach. The two are not redundant:
#   FWRD_ARGS  a command-line variable, so it outranks an `OVERLAY_x = ...` in a dependency's
#              Makefile -- one compiler across the tree. An exported value would lose there.
#   export     the sub-makes started with MAKEFLAGS= and no FWRD_ARGS (wheels, crossenv,
#              publish): a command-line switch is gone from MAKEFLAGS there, and only the
#              environment still carries it to the wheels of the same package.
export OVERLAY_RUSTC OVERLAY_BINUTILS OVERLAY_GCC _OVERLAY_BINUTILS_ASKED

# ---- Degraded states ---------------------------------------------------------------
# Each component defines its own (<c>_MISSING, <c>_VERSION_MISSING, ...), disjoint by
# construction, so the order they are reported in carries no meaning. There is no
# UNMATCHED: "global overlay as/ld on a gcc it is not matched to" is exactly
# OVERLAY_BINUTILS_ON without OVERLAY_GCC_ON, so the target tests that pair.
include $(_OVERLAY_DIR)/warnings.mk

# Once every component is in: the refusal reads OVERLAY_GCC_ON.
ifneq ($(OVERLAY_BINUTILS_REFUSED),)
$(info ===>  *********************************************************************)
$(info ===>  *** OVERLAY_BINUTILS=$(_OVERLAY_BINUTILS_ASKED) cannot be honoured for [$(_OVERLAY_TC)]:)
$(info ===>  *** the gcc $(OVERLAY_GCC_VERS) overlay is active, and drives as/ld through)
$(info ===>  *** binutils $(OVERLAY_BINUTILS_VERS) -- the vendor ones cannot assemble what it emits.)
$(info ===>  *** For the vendor as/ld, set OVERLAY_GCC=0 as well.)
$(info ===>  *********************************************************************)
$(error OVERLAY_BINUTILS=$(_OVERLAY_BINUTILS_ASKED) and the gcc overlay cannot be used together)
endif
