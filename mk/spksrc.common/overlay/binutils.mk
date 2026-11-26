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
#
# Beside the vendor gcc, the default skips the toolchains whose gcc passes the assembler what
# binutils 2.30 rejects: 88f6281's -mcpu=marvell-f. Decided here, where the toolchain is known,
# not in the switch's default, which the first make settles before any arch and forwards. An
# explicit OVERLAY_BINUTILS=1 is still honoured.
_OVERLAY_BINUTILS_VENDOR_GCC_EXCLUDED = syno-88f6281-%
_OVERLAY_BINUTILS_VENDOR_OK = $(if $(call is_true,$(OVERLAY_BINUTILS_ASKED)),1,$(if $(filter $(_OVERLAY_BINUTILS_VENDOR_GCC_EXCLUDED),$(_OVERLAY_TC)),,1))
_OVERLAY_BINUTILS_ON = $(if $(strip $(_OVERLAY_BINUTILS_DIR)),$(if $(_OVERLAY_GCC_ON),1,$(if $(call is_true,$(OVERLAY_BINUTILS)),$(_OVERLAY_BINUTILS_VENDOR_OK))))

# OVERLAY_BINUTILS asked off while the gcc overlay is active: the request cannot be obeyed,
# and building anyway would let the caller believe it was. Stops at parse time, in the
# first make that knows the arch -- before stage0 touches the toolchain.
OVERLAY_BINUTILS_REFUSED = $(if $(_OVERLAY_GCC_ON),$(if $(OVERLAY_BINUTILS_ASKED),$(call is_false,$(OVERLAY_BINUTILS_ASKED))))

# All three uses pull the same archive; they differ only in scope. OVERLAY_BINUTILS counts
# only when asked: its default is on, and must not announce a missing binutils either. The gcc overlay ships
# no as/ld of its own, so without this it would silently drive the vendor ones. The gcc one
# counts only where the arch ships a gcc overlay: elsewhere OVERLAY_GCC=1 asks for nothing,
# and must not announce a missing binutils on every build of a 7.2 arch.
_OVERLAY_BINUTILS_WANTED = $(if $(call is_true,$(OVERLAY_BINUTILS_ASKED))$(call is_true,$(RUSTC_LINK_VIA_BINUTILS_OVERLAY))$(if $(strip $(_OVERLAY_GCC_DIR)),$(call is_true,$(OVERLAY_GCC))),1)

# Degraded states (spksrc.common/overlay.mk): wanted where the arch ships none, or on but
# skipped beside a vendor gcc that emits what it rejects.
OVERLAY_BINUTILS_MISSING   = $(if $(_OVERLAY_BINUTILS_ANY),,$(_OVERLAY_BINUTILS_WANTED))
OVERLAY_BINUTILS_SKIPPED   = $(if $(strip $(_OVERLAY_BINUTILS_DIR)),$(if $(_OVERLAY_BINUTILS_ON),,$(if $(call is_true,$(OVERLAY_BINUTILS)),1)))
