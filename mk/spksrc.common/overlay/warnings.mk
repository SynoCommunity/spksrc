###############################################################################
# spksrc.common/overlay/warnings.mk
#
# What to say about each degraded state of spksrc.common/overlay.mk.
###############################################################################

# Macro: the banner of a component's first degraded state
#
#   overlay-binutils-warn:
#   	@$(call overlay_warn,BINUTILS,VERSION_MISSING MISSING UNMATCHED)
#
# The first <STATE> of the list, in order, whose OVERLAY_<C>_<STATE> is 1, as the text of
# OVERLAY_WARN_<C>_<STATE>; nothing when none is. The order is the priority: one banner
# per component, the most specific first.
overlay_warn = $(OVERLAY_WARN_$(1)_$(firstword $(foreach s,$(2),$(if $(filter 1,$(OVERLAY_$(1)_$(s))),$(s)))))

# Text only; a define is inert, so it costs the packages reading this file nothing. Emitted
# from a recipe: this file is re-parsed several times per build, so $(warning) would repeat.
# Banner style follows spksrc.spk-meta/base.mk.
define OVERLAY_WARN_BINUTILS_MISSING
$(MSG) "*********************************************************************" ; \
$(MSG) "*** No binutils overlay available for [$(_OVERLAY_TC)]" ; \
$(MSG) "*** Falling back to this toolchain's own as/ld" ; \
$(MSG) "*********************************************************************"
endef

# $(1) component, $(2) knob name, $(3) requested version, $(4) dirs the arch ships. Each
# component's OVERLAY_WARN_<C>_VERSION_MISSING calls it (OVERLAY_COMPONENT_TEMPLATE).
define overlay_warn_version_missing
$(MSG) "*********************************************************************" ; \
$(MSG) "*** No $(1) overlay $(3) for [$(_OVERLAY_TC)]" ; \
$(MSG) "*** Available: $(patsubst $(_OVERLAY_TC)_%,%,$(notdir $(4)))" ; \
$(MSG) "*** Overlay disabled -- set $(2) to one of the above" ; \
$(MSG) "*********************************************************************"
endef

define OVERLAY_WARN_RUSTC_GCC_FALLBACK
$(MSG) "*********************************************************************" ; \
$(MSG) "*** No rust $(OVERLAY_RUSTC_VERSION) overlay built with gcc $(OVERLAY_GCC_VERSION) for [$(_OVERLAY_TC)]" ; \
$(MSG) "*** Using $(patsubst $(_OVERLAY_TC)_%,%,$(notdir $(_OVERLAY_RUSTC_VENDOR))) instead" ; \
$(MSG) "*** The rust std is built against the vendor gcc, the C around it is not" ; \
$(MSG) "*********************************************************************"
endef

define OVERLAY_WARN_BINUTILS_UNMATCHED
$(MSG) "*********************************************************************" ; \
$(MSG) "*** OVERLAY_BINUTILS=1: every compile uses binutils $(OVERLAY_BINUTILS_VERSION) as/ld" ; \
$(MSG) "*** paired with the vendor gcc $(TC_GCC_VENDOR), which it is not matched to." ; \
$(MSG) "*** Set OVERLAY_GCC=1 to pair it with gcc $(OVERLAY_GCC_VERSION) instead." ; \
$(MSG) "*********************************************************************"
endef

# The gcc overlay drives as/ld through -B into the binutils shim. Without that shim it
# would reach for the vendor ones -- ld 2.18 on ppc853x -- so say so rather than proceed.
define OVERLAY_WARN_GCC_NO_BINUTILS
$(MSG) "*********************************************************************" ; \
$(MSG) "*** OVERLAY_GCC=1 for [$(_OVERLAY_TC)], but no binutils overlay is active" ; \
$(MSG) "*** gcc $(OVERLAY_GCC_VERSION) would fall back to the vendor as/ld ($(TC_GCC_VENDOR) era)" ; \
$(MSG) "*** Overlay disabled -- provide binutils $(OVERLAY_BINUTILS_VERSION) for this arch" ; \
$(MSG) "*********************************************************************"
endef
