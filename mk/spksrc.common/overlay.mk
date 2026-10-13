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
OVERLAY_BINUTILS_VERS  ?= 2.30
OVERLAY_GCC_VERS       ?= 8.5
# OVERLAY_RUSTC_VERS is NOT pinned here: it defaults to the newest this arch ships, and
# is computed below because the candidate set depends on OVERLAY_GCC_VERS.

# ---- AVAILABLE ---------------------------------------------------------------------
# Non-empty doubles as the path. _ANY ignores the requested version, which is what tells
# "this arch has no overlay" (standard arch) from "not that version" (mis-set knob).
_OVERLAY_RUSTC_ANY    := $(wildcard $(BASEDIR)/overlay/$(_OVERLAY_TC)_rust-*)
_OVERLAY_BINUTILS_ANY := $(wildcard $(BASEDIR)/overlay/$(_OVERLAY_TC)_binutils-*)
_OVERLAY_GCC_ANY      := $(wildcard $(BASEDIR)/overlay/$(_OVERLAY_TC)_gcc-*)
# A rust toolchain is built against a specific gcc, and its directory says which. Both
# variants coexist, so the _gcc-* glob alone would match two; these split them -- first
# across EVERY version the arch ships, to choose the default version from the right pool.
# Every rust consumer this arch ships, minus any marked BROKEN/DISABLED -- the same
# escape hatch packages use. The base toolchain provisions all of them; see below.
_OVERLAY_RUSTC_ENABLED := $(foreach d,$(_OVERLAY_RUSTC_ANY),\
                            $(if $(wildcard $(d)/BROKEN $(d)/DISABLED),,$(d)))
_RUSTC_ANY_MATCHED    := $(filter %_gcc-$(OVERLAY_GCC_VERS),$(_OVERLAY_RUSTC_ANY))
_RUSTC_ANY_VENDOR     := $(filter-out %_gcc-$(OVERLAY_GCC_VERS),$(_OVERLAY_RUSTC_ANY))

# REQUESTED, defaulted here rather than further down: _RUSTC_POOL and TC_OVERLAY_RUSTC
# below are immediate (:=) and read OVERLAY_GCC, so a `?=` after them would leave those
# two seeing an unset switch while everything later sees the default. That was invisible
# while the default was 0 -- unset and 0 read alike -- and mismatches the moment it is 1:
# the gcc overlay asked for, the vendor-gcc rust consumer picked, and stage0 then refuses
# the work dir.
OVERLAY_RUSTC          ?= 1
OVERLAY_BINUTILS       ?= 0
# On by default, tree-wide. A package that selects a meta on TC_GCC and has it built by
# spk-meta-source must agree with it: the selection reads the effective compiler while
# FWRD_ARGS_SPK deliberately does not carry the switch, so the meta decides for itself --
# and only a shared default makes it decide the same way. Inert wherever no overlay exists
# (TC_OVERLAY_GCC empty) and where the vendor gcc is already newer. OVERLAY_BINUTILS
# follows through OVERLAY_BINUTILS_ON: gcc 8.5 needs its assembler.
OVERLAY_GCC            ?= 1
# A typo must not read as "off": anything neither true nor false (macros.mk) stops here.
$(foreach v,OVERLAY_RUSTC OVERLAY_BINUTILS OVERLAY_GCC,$(call assert_bool,$($(v)),$(v)))

# The pool the default is picked from: the gcc-overlay builds when that overlay is on and
# this arch has any, the vendor-gcc ones otherwise. Same preference as the selection below,
# applied one step earlier so "newest" means newest OF THE VARIANT that will be used --
# picking 1.98 from the gcc-8.5 pool and then failing to find a vendor 1.98 would be worse
# than picking the newest vendor version in the first place.
_RUSTC_POOL           := $(if $(call is_true,$(OVERLAY_GCC)),\
                           $(or $(_RUSTC_ANY_MATCHED),$(_RUSTC_ANY_VENDOR)),\
                           $(_RUSTC_ANY_VENDOR))
# Directory name -> bare version (syno-qoriq-6.2.4_rust-1.98_gcc-8.5 -> 1.98), newest first.
_RUSTC_POOL_VERS      := $(shell printf '%s\n' $(patsubst $(_OVERLAY_TC)_rust-%,%,$(notdir $(_RUSTC_POOL))) \
                           | sed 's/_gcc-.*//' | sort -Vru)

# Newest available, unless the caller pinned one. `?=` is the whole mechanism: a command
# line, the environment or a package Makefile all win over it, which is what "default"
# means here -- nothing below can tell the difference.
OVERLAY_RUSTC_VERS    ?= $(firstword $(_RUSTC_POOL_VERS))

_OVERLAY_RUSTC_ALL    := $(wildcard $(BASEDIR)/overlay/$(_OVERLAY_TC)_rust-$(OVERLAY_RUSTC_VERS)_gcc-*)
_OVERLAY_RUSTC_MATCHED := $(filter %_gcc-$(OVERLAY_GCC_VERS),$(_OVERLAY_RUSTC_ALL))
_OVERLAY_RUSTC_VENDOR  := $(filter-out %_gcc-$(OVERLAY_GCC_VERS),$(_OVERLAY_RUSTC_ALL))

# With the gcc overlay ON, PREFER the rustc built against it, and fall back to the vendor
# one where that arch has none: a rust toolchain built with the vendor gcc still links
# against the same glibc, so it stays usable -- having no rustc overlay at all would not.
# With the gcc overlay OFF, only the vendor one is a candidate; taking the gcc-8.5 build
# there would pair it with a compiler it was not built against.
TC_OVERLAY_RUSTC      := $(if $(call is_true,$(OVERLAY_GCC)),\
                           $(or $(_OVERLAY_RUSTC_MATCHED),$(_OVERLAY_RUSTC_VENDOR)),\
                           $(_OVERLAY_RUSTC_VENDOR))
TC_OVERLAY_BINUTILS   := $(wildcard $(BASEDIR)/overlay/$(_OVERLAY_TC)_binutils-$(OVERLAY_BINUTILS_VERS))
TC_OVERLAY_GCC        := $(wildcard $(BASEDIR)/overlay/$(_OVERLAY_TC)_gcc-$(OVERLAY_GCC_VERS))

# ---- REQUESTED (switches) ----------------------------------------------------------
# OVERLAY_RUSTC          custom from-source rustc + synology triple; 0 is diagnostic only,
#                        these archs ship an overlay because the stock std does not fit.
# OVERLAY_BINUTILS       GLOBAL: overlay as/ld for EVERY compile. Needs a matched modern
#                        gcc, hence off by default -- OVERLAY_GCC is what matches it, and
#                        turns it on (OVERLAY_BINUTILS_ON); asking 0 alongside an active
#                        gcc overlay stops the build (OVERLAY_BINUTILS_REFUSED).
# RUST_LINK_VIA_BINUTILS NARROW: only the Rust link takes the overlay ld; C keeps the vendor's.
# OVERLAY_GCC            a modern gcc beside the vendor one, selected by version suffix. On by
#                        default (above); inert where the arch ships none.
# The three switches are defaulted above, before the pools that read them.
RUST_LINK_VIA_BINUTILS ?= $(if $(strip $(TC_OVERLAY_RUSTC)),1)

# What the caller ASKED of OVERLAY_BINUTILS, as opposed to a default: only the command line
# or the environment of the make they typed express a request -- local.mk holds `?=`
# defaults like this file, so a "file" origin cannot tell the two apart. Decided once, by the
# first make, and carried from there (FWRD_VARS, export below): every later make receives
# the switch from its parent, on its command line or in its environment, and would read the
# forwarded default as a request.
ifeq ($(origin _OVERLAY_BINUTILS_ASKED),undefined)
_OVERLAY_BINUTILS_ASKED := $(if $(filter command environment,$(firstword $(origin OVERLAY_BINUTILS))),$(strip $(OVERLAY_BINUTILS)))
endif

# Carried to every sub-make that resolves a toolchain WITHIN this package (FWRD_ARGS).
# Deliberately absent from FWRD_ARGS_SPK: which compiler a package builds with belongs
# to that package and its own work dir, so an spk built as another's meta decides for
# itself rather than inheriting its caller's choice. Not RUST_LINK_VIA_BINUTILS: it
# derives from TC_OVERLAY_RUSTC, which the child reads itself.
FWRD_VARS += OVERLAY_RUSTC OVERLAY_BINUTILS OVERLAY_GCC _OVERLAY_BINUTILS_ASKED

# The only way the _VERS pins travel: objects from gcc 4.3.7 will not mix with gcc 8.5
# C++, so a choice must hold tree-wide. The switches themselves are exported below.
export OVERLAY_BINUTILS_VERS OVERLAY_GCC_VERS
# OVERLAY_RUSTC_VERS is exported ONLY once it has a value. It is derived from the rust
# consumer dirs this arch ships, and there are contexts where that list is legitimately
# empty -- a toolchain consumer directory resolves _OVERLAY_TC to syno-native, which owns
# no rust overlay. Exporting it there would put an EMPTY value in the environment of every
# sub-make, and `?=` cannot override an environment variable that is set, even to nothing:
# the child would inherit "no version" and disable its own overlay. `export` alone is
# enough to create that empty value, so the guard has to be on the export, not the
# assignment.
ifneq ($(strip $(OVERLAY_RUSTC_VERS)),)
export OVERLAY_RUSTC_VERS
endif

# Exported as well, for what FWRD_ARGS cannot reach. The two are not redundant:
#   FWRD_ARGS  a command-line variable, so it outranks an `OVERLAY_x = ...` in a dependency's
#              Makefile -- one compiler across the tree. An exported value would lose there.
#   export     the sub-makes started with MAKEFLAGS= and no FWRD_ARGS (wheels, crossenv,
#              publish): a command-line switch is gone from MAKEFLAGS there, and only the
#              environment still carries it to the wheels of the same package.
export OVERLAY_RUSTC OVERLAY_BINUTILS OVERLAY_GCC _OVERLAY_BINUTILS_ASKED

# ---- ACTIVE ------------------------------------------------------------------------
# Lazy (=): local.mk is read before this file, but a switch may also arrive from the
# environment or the command line. The wildcards above stay immediate.
OVERLAY_RUSTC_ON     = $(if $(strip $(TC_OVERLAY_RUSTC)),$(if $(call is_true,$(OVERLAY_RUSTC)),1))
# A gcc overlay turns this on unconditionally: gcc reaches as/ld only through
# OVERLAY_BINUTILS_FLAG, so the pair is ONE decision -- gcc 8.5 on the vendor as/ld cannot
# assemble what it emits. A package therefore activates OVERLAY_GCC alone; an explicit
# OVERLAY_BINUTILS=0 beside it is refused below. No cycle: OVERLAY_GCC_ON tests
# availability, not this.
OVERLAY_BINUTILS_ON  = $(if $(strip $(TC_OVERLAY_BINUTILS)),$(if $(call is_true,$(OVERLAY_BINUTILS))$(OVERLAY_GCC_ON),1))

# GCC additionally requires binutils to be available: it drives as/ld through -B into that
# overlay's shim, and the vendor ones cannot assemble what a modern gcc emits.
OVERLAY_GCC_ON       = $(if $(strip $(TC_OVERLAY_GCC)),$(if $(strip $(TC_OVERLAY_BINUTILS)),$(if $(call is_true,$(OVERLAY_GCC)),1)))

# OVERLAY_BINUTILS asked off while the gcc overlay is active: the request cannot be obeyed,
# and building anyway would let the caller believe it was. Stops at parse time, in the
# first make that knows the arch -- before stage0 touches the toolchain.
OVERLAY_BINUTILS_REFUSED = $(if $(OVERLAY_GCC_ON),$(if $(_OVERLAY_BINUTILS_ASKED),$(call is_false,$(_OVERLAY_BINUTILS_ASKED))))

# All three uses pull the same archive; they differ only in scope. The gcc overlay ships
# no as/ld of its own, so without this it would silently drive the vendor ones. The gcc one
# counts only where the arch ships a gcc overlay: elsewhere the default OVERLAY_GCC=1 asks
# for nothing, and must not announce a missing binutils on every build of a 7.2 arch.
_OVERLAY_BINUTILS_WANTED    = $(if $(call is_true,$(OVERLAY_BINUTILS))$(call is_true,$(RUST_LINK_VIA_BINUTILS))$(if $(strip $(TC_OVERLAY_GCC)),$(call is_true,$(OVERLAY_GCC))),1)
OVERLAY_BINUTILS_PROVISION  = $(if $(strip $(TC_OVERLAY_BINUTILS)),$(_OVERLAY_BINUTILS_WANTED))

# ---- Degraded states, and what to say about them ------------------------------------
# Disjoint by construction, so the order they are reported in carries no meaning. There is
# no UNMATCHED: "global overlay as/ld on a gcc it is not matched to" is exactly
# OVERLAY_BINUTILS_ON without OVERLAY_GCC_ON, so the target tests that pair.
OVERLAY_BINUTILS_MISSING         = $(if $(_OVERLAY_BINUTILS_ANY),,$(_OVERLAY_BINUTILS_WANTED))
OVERLAY_RUSTC_VERSION_MISSING    = $(if $(_OVERLAY_RUSTC_ANY),$(if $(strip $(TC_OVERLAY_RUSTC)),,1))
OVERLAY_BINUTILS_VERSION_MISSING = $(if $(_OVERLAY_BINUTILS_ANY),$(if $(strip $(TC_OVERLAY_BINUTILS)),,1))
OVERLAY_GCC_VERSION_MISSING      = $(if $(_OVERLAY_GCC_ANY),$(if $(strip $(TC_OVERLAY_GCC)),,1))
OVERLAY_GCC_NO_BINUTILS          = $(if $(strip $(TC_OVERLAY_GCC)),$(if $(strip $(TC_OVERLAY_BINUTILS)),,$(if $(call is_true,$(OVERLAY_GCC)),1)))
# Not a failure: the gcc overlay is on, this arch ships no rustc built against it, and the
# vendor-gcc one was taken instead. Worth saying, because the rust std then comes from a
# different compiler than the C around it.
OVERLAY_RUSTC_GCC_FALLBACK       = $(if $(call is_true,$(OVERLAY_GCC)),$(if $(strip $(_OVERLAY_RUSTC_MATCHED)),,$(if $(strip $(_OVERLAY_RUSTC_VENDOR)),1)))

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

define OVERLAY_WARN_RUSTC_GCC_FALLBACK
$(MSG) "*********************************************************************" ; \
$(MSG) "*** No rust $(OVERLAY_RUSTC_VERS) overlay built with gcc $(OVERLAY_GCC_VERS) for [$(_OVERLAY_TC)]" ; \
$(MSG) "*** Using $(patsubst $(_OVERLAY_TC)_%,%,$(notdir $(_OVERLAY_RUSTC_VENDOR))) instead" ; \
$(MSG) "*** The rust std is built against the vendor gcc, the C around it is not" ; \
$(MSG) "*********************************************************************"
endef
OVERLAY_WARN_BINUTILS_VERSION_MISSING = $(call overlay_warn_version_missing,binutils,OVERLAY_BINUTILS_VERS,$(OVERLAY_BINUTILS_VERS),$(_OVERLAY_BINUTILS_ANY))
OVERLAY_WARN_GCC_VERSION_MISSING      = $(call overlay_warn_version_missing,gcc,OVERLAY_GCC_VERS,$(OVERLAY_GCC_VERS),$(_OVERLAY_GCC_ANY))

define OVERLAY_WARN_BINUTILS_UNMATCHED
$(MSG) "*********************************************************************" ; \
$(MSG) "*** OVERLAY_BINUTILS=1: every compile uses binutils $(OVERLAY_BINUTILS_VERS) as/ld" ; \
$(MSG) "*** paired with the vendor gcc $(TC_GCC_VENDOR), which it is not matched to." ; \
$(MSG) "*** Set OVERLAY_GCC=1 to pair it with gcc $(OVERLAY_GCC_VERS) instead." ; \
$(MSG) "*********************************************************************"
endef

# The gcc overlay drives as/ld through -B into the binutils shim. Without that shim it
# would reach for the vendor ones -- ld 2.18 on ppc853x -- so say so rather than proceed.
define OVERLAY_WARN_GCC_NO_BINUTILS
$(MSG) "*********************************************************************" ; \
$(MSG) "*** OVERLAY_GCC=1 for [$(_OVERLAY_TC)], but no binutils overlay is active" ; \
$(MSG) "*** gcc $(OVERLAY_GCC_VERS) would fall back to the vendor as/ld ($(TC_GCC_VENDOR) era)" ; \
$(MSG) "*** Overlay disabled -- provide binutils $(OVERLAY_BINUTILS_VERS) for this arch" ; \
$(MSG) "*********************************************************************"
endef

ifneq ($(OVERLAY_BINUTILS_REFUSED),)
$(info ===>  *********************************************************************)
$(info ===>  *** OVERLAY_BINUTILS=$(_OVERLAY_BINUTILS_ASKED) cannot be honoured for [$(_OVERLAY_TC)]:)
$(info ===>  *** the gcc $(OVERLAY_GCC_VERS) overlay is active, and drives as/ld through)
$(info ===>  *** binutils $(OVERLAY_BINUTILS_VERS) -- the vendor ones cannot assemble what it emits.)
$(info ===>  *** For the vendor as/ld, set OVERLAY_GCC=0 as well.)
$(info ===>  *********************************************************************)
$(error OVERLAY_BINUTILS=$(_OVERLAY_BINUTILS_ASKED) and the gcc overlay cannot be used together)
endif
