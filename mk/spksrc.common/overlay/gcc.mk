###############################################################################
# spksrc.common/overlay/gcc.mk
#
# The gcc overlay: available, requested, active. Read by spksrc.common/overlay.mk, after
# binutils.mk: this one is active only beside an available binutils overlay.
###############################################################################

# _OVERLAY_GCC_ANY, TC_OVERLAY_GCC, OVERLAY_GCC_VERSION_MISSING and its banner.
$(eval $(call OVERLAY_COMPONENT_TEMPLATE,GCC,gcc))

# GCC additionally requires binutils to be available: it drives as/ld through -B into that
# overlay's shim, and the vendor ones cannot assemble what a modern gcc emits.
OVERLAY_GCC_ON       = $(if $(strip $(TC_OVERLAY_GCC)),$(if $(strip $(TC_OVERLAY_BINUTILS)),$(if $(call is_true,$(OVERLAY_GCC)),1)))

# Degraded state (spksrc.common/overlay.mk): no binutils to drive.
OVERLAY_GCC_NO_BINUTILS          = $(if $(strip $(TC_OVERLAY_GCC)),$(if $(strip $(TC_OVERLAY_BINUTILS)),,$(if $(call is_true,$(OVERLAY_GCC)),1)))
