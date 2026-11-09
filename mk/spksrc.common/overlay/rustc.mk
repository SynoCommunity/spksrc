###############################################################################
# spksrc.common/overlay/rustc.mk
#
# The rust overlay: available, requested, active. Read by spksrc.common/overlay.mk, last
# of the components: which build is picked depends on OVERLAY_GCC and OVERLAY_GCC_VERSION,
# both set before any component is read.
###############################################################################

# ---- AVAILABLE ---------------------------------------------------------------------
# _OVERLAY_RUSTC_ANY, OVERLAY_RUSTC_VERSION_MISSING and its banner; OVERLAY_RUSTC_VERSION and
# _OVERLAY_RUSTC_DIR are picked below. _ANY ignores the requested version, which is what tells
# "this arch has no overlay" (standard arch) from "not that version" (mis-set knob).
$(eval $(call OVERLAY_COMPONENT_TEMPLATE,RUSTC,rust,select))

# Every rust consumer this arch ships, minus any marked BROKEN/DISABLED -- the same
# escape hatch packages use. The base toolchain provisions all of them (TC_OVERLAY_ALL).
_OVERLAY_RUSTC_ENABLED := $(foreach d,$(_OVERLAY_RUSTC_ANY),\
                                    $(if $(wildcard $(d)/BROKEN $(d)/DISABLED),,$(d)))

# A rust toolchain is built against a specific gcc, and its directory says which. Both
# variants coexist, so the _gcc-* glob alone would match two; these split them -- first
# across EVERY version the arch ships, to choose the default version from the right pool.
_OVERLAY_RUSTC_ANY_MATCHED := $(filter %_gcc-$(OVERLAY_GCC_VERSION),$(_OVERLAY_RUSTC_ANY))
_OVERLAY_RUSTC_ANY_VENDOR  := $(filter-out %_gcc-$(OVERLAY_GCC_VERSION),$(_OVERLAY_RUSTC_ANY))

# The pool the default is picked from: the gcc-overlay builds when that overlay is on and
# this arch has any, the vendor-gcc ones otherwise. Same preference as the selection below,
# applied one step earlier so "newest" means newest OF THE VARIANT that will be used --
# picking 1.98 from the gcc-8.5 pool and then failing to find a vendor 1.98 would be worse
# than picking the newest vendor version in the first place.
_OVERLAY_RUSTC_POOL := $(if $(call is_true,$(OVERLAY_GCC)),\
                            $(or $(_OVERLAY_RUSTC_ANY_MATCHED),$(_OVERLAY_RUSTC_ANY_VENDOR)),\
                            $(_OVERLAY_RUSTC_ANY_VENDOR))
# Directory name -> bare version (syno-qoriq-6.2.4_rust-1.98_gcc-8.5 -> 1.98), each once.
_OVERLAY_RUSTC_POOL_NAMES    := $(patsubst $(_OVERLAY_TC)_rust-%,%,$(notdir $(_OVERLAY_RUSTC_POOL)))
_OVERLAY_RUSTC_POOL_VERSIONS := $(sort $(foreach v,$(_OVERLAY_RUSTC_POOL_NAMES),$(firstword $(subst _gcc-, ,$(v)))))

# Newest available, unless the caller pinned one: a command line, the environment or a
# package Makefile all win, which is what "default" means here. Immediate, unlike a `?=`:
# picking the newest of two forks a shell, once.
ifeq ($(origin OVERLAY_RUSTC_VERSION),undefined)
OVERLAY_RUSTC_VERSION := $(call _overlay_newest,$(_OVERLAY_RUSTC_POOL_VERSIONS))
_OVERLAY_RUSTC_VERSION_DEFAULTED := 1
endif

_OVERLAY_RUSTC_ALL     := $(wildcard $(BASEDIR)/overlay/$(_OVERLAY_TC)_rust-$(OVERLAY_RUSTC_VERSION)_gcc-*)
_OVERLAY_RUSTC_MATCHED := $(filter %_gcc-$(OVERLAY_GCC_VERSION),$(_OVERLAY_RUSTC_ALL))
_OVERLAY_RUSTC_VENDOR  := $(filter-out %_gcc-$(OVERLAY_GCC_VERSION),$(_OVERLAY_RUSTC_ALL))

# With the gcc overlay ON, PREFER the rustc built against it, and fall back to the vendor
# one where that arch has none: a rust toolchain built with the vendor gcc still links
# against the same glibc, so it stays usable -- having no rustc overlay at all would not.
# With the gcc overlay OFF, only the vendor one is a candidate; taking the gcc-8.5 build
# there would pair it with a compiler it was not built against.
_OVERLAY_RUSTC_DIR := $(if $(call is_true,$(OVERLAY_GCC)),\
                           $(or $(_OVERLAY_RUSTC_MATCHED),$(_OVERLAY_RUSTC_VENDOR)),\
                           $(_OVERLAY_RUSTC_VENDOR))

# NARROW: only the Rust link takes the overlay ld; C keeps the vendor's.
RUST_LINK_VIA_BINUTILS ?= $(if $(strip $(_OVERLAY_RUSTC_DIR)),1)

# Lazy (=), like the other components' ACTIVE.
_OVERLAY_RUSTC_ON = $(if $(strip $(_OVERLAY_RUSTC_DIR)),$(if $(call is_true,$(OVERLAY_RUSTC)),1))

# Degraded state (spksrc.common/overlay.mk), not a failure: the gcc overlay is on, this
# arch ships no rustc built against it, and the vendor-gcc one was taken instead. Worth
# saying, because the rust std then comes from a different compiler than the C around it.
OVERLAY_RUSTC_GCC_FALLBACK = $(if $(call is_true,$(OVERLAY_GCC)),$(if $(strip $(_OVERLAY_RUSTC_MATCHED)),,$(if $(strip $(_OVERLAY_RUSTC_VENDOR)),1)))
