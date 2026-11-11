###############################################################################
# spksrc.common/overlay/binutils.mk
#
# The binutils overlay: available, requested, active. Read by spksrc.common/overlay.mk,
# after the switches and before gcc.mk, whose _OVERLAY_GCC_ON this reads lazily.
###############################################################################

# _OVERLAY_BINUTILS_ANY, OVERLAY_BINUTILS_VERSION, _OVERLAY_BINUTILS_DIR,
# OVERLAY_BINUTILS_VERSION_MISSING and its banner.
$(eval $(call OVERLAY_COMPONENT_TEMPLATE,BINUTILS,binutils))

# What the caller ASKED of OVERLAY_BINUTILS, as opposed to a default: only the command line
# or the environment of the make they typed express a request -- local.mk holds `?=`
# defaults like this file, so a "file" origin cannot tell the two apart. Decided once, by the
# first make, and carried from there (FWRD_VARS and export, spksrc.common/overlay.mk):
# every later make receives the switch from its parent, on its command line or in its
# environment, and would read the forwarded default as a request.
ifeq ($(origin OVERLAY_BINUTILS_ASKED),undefined)
OVERLAY_BINUTILS_ASKED := $(if $(filter command environment,$(firstword $(origin OVERLAY_BINUTILS))),$(strip $(OVERLAY_BINUTILS)))
endif

# A gcc overlay turns this on unconditionally: gcc reaches as/ld only through
# OVERLAY_BINUTILS_FLAG, so the pair is ONE decision -- gcc 8.5 on the vendor as/ld cannot
# assemble what it emits. A package therefore activates OVERLAY_GCC alone; an explicit
# OVERLAY_BINUTILS=0 beside it is refused (spksrc.common/overlay.mk). No cycle:
# _OVERLAY_GCC_ON tests availability, not this.
_OVERLAY_BINUTILS_ON = $(if $(strip $(_OVERLAY_BINUTILS_DIR)),$(if $(call is_true,$(OVERLAY_BINUTILS))$(_OVERLAY_GCC_ON),1))

# OVERLAY_BINUTILS asked off while the gcc overlay is active: the request cannot be obeyed,
# and building anyway would let the caller believe it was. Stops at parse time, in the
# first make that knows the arch -- before stage0 touches the toolchain.
OVERLAY_BINUTILS_REFUSED = $(if $(_OVERLAY_GCC_ON),$(if $(OVERLAY_BINUTILS_ASKED),$(call is_false,$(OVERLAY_BINUTILS_ASKED))))

# All three uses pull the same archive; they differ only in scope. The gcc overlay ships
# no as/ld of its own, so without this it would silently drive the vendor ones. The gcc one
# counts only where the arch ships a gcc overlay: elsewhere OVERLAY_GCC=1 asks for nothing,
# and must not announce a missing binutils on every build of a 7.2 arch.
_OVERLAY_BINUTILS_WANTED = $(if $(call is_true,$(OVERLAY_BINUTILS))$(call is_true,$(RUST_LINK_VIA_BINUTILS))$(if $(strip $(_OVERLAY_GCC_DIR)),$(call is_true,$(OVERLAY_GCC))),1)

# Degraded states (spksrc.common/overlay.mk): wanted where the arch ships none, or active
# beside the vendor gcc, which it is not matched to.
OVERLAY_BINUTILS_MISSING   = $(if $(_OVERLAY_BINUTILS_ANY),,$(_OVERLAY_BINUTILS_WANTED))
OVERLAY_BINUTILS_UNMATCHED = $(if $(_OVERLAY_BINUTILS_ON),$(if $(_OVERLAY_GCC_ON),,1))
