###############################################################################
# spksrc.common/overlay/binutils.mk
#
# The binutils overlay: available, requested, active. Read by spksrc.common/overlay.mk,
# after the switches and before gcc.mk, whose OVERLAY_GCC_ON this reads lazily.
###############################################################################

# _OVERLAY_BINUTILS_ANY, TC_OVERLAY_BINUTILS, OVERLAY_BINUTILS_VERSION_MISSING and its banner.
$(eval $(call OVERLAY_COMPONENT_TEMPLATE,BINUTILS,binutils))

# The as/ld version the GLOBAL overlay supplies, as the consumer's own PKG_VERS -- what
# tc-capability.mk reports for TC_BINUTILS when the overlay drives this build, so a
# MIN_BINUTILS_VERSION floor measures the linker the compile will really use rather than
# the vendor one it replaces. Empty when the overlay is off or the arch has none.
#
# Immediate, and deliberately not TC_OVERLAY_BINUTILS or OVERLAY_BINUTILS_ON read back
# later: the generated tc_vars.mk emits TC_OVERLAY_BINUTILS with ACTIVE semantics and
# stage0.mk includes that file ahead of tc-capability.mk, so a work dir generated with the
# overlay off would hand back an empty one and the floor would see the vendor version.
OVERLAY_BINUTILS_PKG_VERS := $(if $(call is_true,$(OVERLAY_BINUTILS)),$(call read_makefile_var,$(firstword $(TC_OVERLAY_BINUTILS))/Makefile,PKG_VERS))

# The effective as/ld version, given the vendor one to fall back to. Two callers, because
# TC_BINUTILS reaches them from different places: tc-capability.mk reads it out of the
# toolchain's Makefile for a package, while a toolchain declares its own and
# spksrc.toolchain/tc_vars.mk emits it. One macro so they cannot drift apart.
overlay_binutils_vers = $(or $(strip $(OVERLAY_BINUTILS_PKG_VERS)),$(strip $(1)))

# What the caller ASKED of OVERLAY_BINUTILS, as opposed to a default: only the command line
# or the environment of the make they typed express a request -- local.mk holds `?=`
# defaults like this file, so a "file" origin cannot tell the two apart. Decided once, by the
# first make, and carried from there (FWRD_VARS, export -- spksrc.common/overlay.mk): every later make receives
# the switch from its parent, on its command line or in its environment, and would read the
# forwarded default as a request.
ifeq ($(origin _OVERLAY_BINUTILS_ASKED),undefined)
_OVERLAY_BINUTILS_ASKED := $(if $(filter command environment,$(firstword $(origin OVERLAY_BINUTILS))),$(strip $(OVERLAY_BINUTILS)))
endif

# A gcc overlay turns this on unconditionally: gcc reaches as/ld only through
# OVERLAY_BINUTILS_FLAG, so the pair is ONE decision -- gcc 8.5 on the vendor as/ld cannot
# assemble what it emits. A package therefore activates OVERLAY_GCC alone; an explicit
# OVERLAY_BINUTILS=0 beside it is refused (spksrc.common/overlay.mk). No cycle: OVERLAY_GCC_ON tests
# availability, not this.
OVERLAY_BINUTILS_ON  = $(if $(strip $(TC_OVERLAY_BINUTILS)),$(if $(call is_true,$(OVERLAY_BINUTILS))$(OVERLAY_GCC_ON),1))

# OVERLAY_BINUTILS asked off while the gcc overlay is active: the request cannot be obeyed,
# and building anyway would let the caller believe it was. Stops at parse time, in the
# first make that knows the arch -- before stage0 touches the toolchain.
OVERLAY_BINUTILS_REFUSED = $(if $(OVERLAY_GCC_ON),$(if $(_OVERLAY_BINUTILS_ASKED),$(call is_false,$(_OVERLAY_BINUTILS_ASKED))))

# All three uses pull the same archive; they differ only in scope. The gcc overlay ships
# no as/ld of its own, so without this it would silently drive the vendor ones. The gcc one
# counts only where the arch ships a gcc overlay: elsewhere the default OVERLAY_GCC=1 asks
# for nothing, and must not announce a missing binutils on every build of a 7.2 arch.
_OVERLAY_BINUTILS_WANTED    = $(if $(call is_true,$(OVERLAY_BINUTILS))$(call is_true,$(RUST_LINK_VIA_BINUTILS))$(if $(strip $(TC_OVERLAY_GCC)),$(call is_true,$(OVERLAY_GCC))),1)

# Degraded states (spksrc.common/overlay.mk): wanted where the arch ships none, or active
# beside the vendor gcc, which it is not matched to.
OVERLAY_BINUTILS_MISSING         = $(if $(_OVERLAY_BINUTILS_ANY),,$(_OVERLAY_BINUTILS_WANTED))
OVERLAY_BINUTILS_UNMATCHED       = $(if $(OVERLAY_BINUTILS_ON),$(if $(OVERLAY_GCC_ON),,1))
