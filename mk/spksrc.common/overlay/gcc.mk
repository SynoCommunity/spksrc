###############################################################################
# spksrc.common/overlay/gcc.mk
#
# The gcc overlay: available, requested, active. Read by spksrc.common/overlay.mk, after
# binutils.mk: this one is active only beside an available binutils overlay.
###############################################################################

_OVERLAY_GCC_ANY      := $(wildcard $(BASEDIR)/overlay/$(_OVERLAY_TC)_gcc-*)
TC_OVERLAY_GCC        := $(wildcard $(BASEDIR)/overlay/$(_OVERLAY_TC)_gcc-$(OVERLAY_GCC_VERS))

# GCC additionally requires binutils to be available: it drives as/ld through -B into that
# overlay's shim, and the vendor ones cannot assemble what a modern gcc emits.
OVERLAY_GCC_ON       = $(if $(strip $(TC_OVERLAY_GCC)),$(if $(strip $(TC_OVERLAY_BINUTILS)),$(if $(call is_true,$(OVERLAY_GCC)),1)))

# Degraded states (spksrc.common/overlay.mk): not that version, or no binutils to drive.
OVERLAY_GCC_VERSION_MISSING      = $(if $(_OVERLAY_GCC_ANY),$(if $(strip $(TC_OVERLAY_GCC)),,1))
OVERLAY_GCC_NO_BINUTILS          = $(if $(strip $(TC_OVERLAY_GCC)),$(if $(strip $(TC_OVERLAY_BINUTILS)),,$(if $(call is_true,$(OVERLAY_GCC)),1)))
