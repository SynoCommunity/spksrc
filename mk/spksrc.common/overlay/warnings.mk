###############################################################################
# spksrc.common/overlay/warnings.mk
#
# What to say about each degraded state of spksrc.common/overlay.mk.
###############################################################################

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
