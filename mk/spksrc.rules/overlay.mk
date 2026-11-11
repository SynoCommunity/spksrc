###############################################################################
# spksrc.rules/overlay.mk
#
# make overlay / overlay-<arch>-<tcvers>: the report of what each overlay resolves to,
# also printed at the start of every arch build. The decisions themselves are in
# spksrc.common/overlay.mk; this file only reports them. Included by supported.mk.
###############################################################################

# What each overlay resolves to for ARCH/TCVERSION with this run's switches -- ON/OFF, the
# consumer taken, those the arch ships -- what degrades, and whether the work dir's
# tc_vars.overlay.mk agrees (stage0.mk stops a build that does not).
# Pure diagnostic, like check: parses, builds nothing.
# A component's shipped versions ($(1) BINUTILS/GCC, $(2) its dir name); what was asked of
# it -- "default" unless OVERLAY_<C>_VERSION was set; rust's, per gcc it was built with.
_ovl_versions  = $(patsubst $(_OVERLAY_TC)_$(2)-%,%,$(notdir $(_OVERLAY_$(1)_ANY)))
_ovl_asked     = $(if $(_OVERLAY_$(1)_VERSION_DEFAULTED),default,$(OVERLAY_$(1)_VERSION))
_ovl_rust_gccs = $(sort $(foreach d,$(notdir $(_OVERLAY_RUSTC_ANY)),$(lastword $(subst _gcc-, ,$(d)))))
_ovl_rust_vers = $(sort $(foreach d,$(filter %_gcc-$(1),$(notdir $(_OVERLAY_RUSTC_ANY))),$(firstword $(subst _gcc-, ,$(patsubst $(_OVERLAY_TC)_rust-%,%,$(d))))))
_ovl_rust_gcc  = $(lastword $(subst _gcc-, ,$(notdir $(firstword $(_OVERLAY_RUSTC_DIR)))))
_ovl_rust_pool = $(if $(_OVERLAY_GCC_ON),$(OVERLAY_GCC_VERSION),$(TC_GCC))
_ovl_rule      = ======================================================================
_ovl_line      = printf "         %s\n"
# One versions row: switch (or blank), what the versions are, them, the default, a marker.
_ovl_vers      = printf "         %-34s %-15s %-12s default: %s%s\n"
_ovl_pair      = printf "         %-34s %s\n"
_ovl_none      = printf "         %-34s %-15s %s\n"

# binutils and gcc: the state, the switch, the version asked against those shipped.
define _overlay_report_component
@printf "       %s: %s\n" "$(2)" "$(if $(_OVERLAY_$(1)_ON),ON ($(OVERLAY_$(1)_VERSION)),OFF)"
@$(_ovl_line) "OVERLAY_$(1)=$(strip $(OVERLAY_$(1)))"
@$(if $(call _ovl_versions,$(1),$(2)),$(_ovl_vers) "OVERLAY_$(1)_VERSION=$(call _ovl_asked,$(1))" "available:" "$(call _ovl_versions,$(1),$(2))" "$(call _overlay_newest,$(call _ovl_versions,$(1),$(2)))" "",$(_ovl_none) "OVERLAY_$(1)_VERSION=$(call _ovl_asked,$(1))" "available:" "none")
endef

# An arch that ships none -- most of them -- gets one line.
.PHONY: overlay
overlay:
ifeq ($(strip $(_OVERLAY_BINUTILS_ANY)$(_OVERLAY_GCC_ANY)$(_OVERLAY_RUSTC_ANY)),)
	@$(MSG) "$(NAME): $(ARCH)-$(TCVERSION) overlays: none shipped for this arch"
else
	@$(MSG) "$(NAME): $(ARCH)-$(TCVERSION) overlays"
	@printf "       %s\n" "WORK_DIR: $(notdir $(WORK_DIR)) (tc_vars.overlay.mk: $(if $(_TC_VARS_OVERLAY_EXISTED),$(if $(_TC_VARS_OVERLAY_CHANGED),ERROR -> $(foreach c,$(_TC_VARS_OVERLAY_CHANGED),$(call lower,$(c)) $(if $(filter TRUE,$(TC_OVERLAY_$(c)_ON)),ON,OFF)$(,) this run $(if $(_OVERLAY_$(c)_ON),ON,OFF)): make clean first,OK),n/a))"
	$(call _overlay_report_component,BINUTILS,binutils)
	@$(if $(_OVERLAY_BINUTILS_ON),$(if $(call is_true,$(OVERLAY_BINUTILS)),,$(_ovl_line) "note: ON for the gcc overlay (it drives as/ld)" ;))
	@$(if $(OVERLAY_BINUTILS_MISSING),$(_ovl_line) "note: requested but the arch ships none" ;)
	@$(if $(OVERLAY_BINUTILS_VERSION_MISSING),$(_ovl_line) "note: binutils $(OVERLAY_BINUTILS_VERSION) is not shipped here" ;)
	@$(if $(OVERLAY_BINUTILS_UNMATCHED),$(_ovl_line) "note: ON beside the vendor gcc it is not matched to" ;)
	$(call _overlay_report_component,GCC,gcc)
	@$(if $(OVERLAY_GCC_VERSION_MISSING),$(_ovl_line) "note: gcc $(OVERLAY_GCC_VERSION) is not shipped here" ;)
	@$(if $(OVERLAY_GCC_NO_BINUTILS),$(_ovl_line) "note: asked without a binutils overlay to drive: vendor gcc kept" ;)
	@printf "       %s: %s\n" "rustc" "$(if $(_OVERLAY_RUSTC_ON),ON ($(OVERLAY_RUSTC_VERSION) built with gcc $(_ovl_rust_gcc)),OFF)"
	@$(_ovl_pair) "RUST_LINK_VIA_BINUTILS=$(or $(strip $(RUST_LINK_VIA_BINUTILS)),0)" "with binutils $(if $(filter 1,$(RUST_LINK_VIA_BINUTILS)),$(OVERLAY_BINUTILS_VERSION) from overlay,$(call read_makefile_var,$(_TC_CAP_MK),TC_BINUTILS) from vendor)"
	@$(_ovl_line) "OVERLAY_RUSTC=$(strip $(OVERLAY_RUSTC))"
	@$(if $(_ovl_rust_gccs),$(foreach g,$(_ovl_rust_gccs),$(_ovl_vers) "$(if $(filter $(g),$(firstword $(_ovl_rust_gccs))),OVERLAY_RUSTC_VERSION=$(call _ovl_asked,RUSTC))" "with gcc $(g):" "$(call _ovl_rust_vers,$(g))" "$(call _overlay_newest,$(call _ovl_rust_vers,$(g)))" "$(if $(_OVERLAY_RUSTC_ON),$(if $(filter $(g),$(_ovl_rust_gcc)),   <- this build))" ;),$(_ovl_none) "OVERLAY_RUSTC_VERSION=$(call _ovl_asked,RUSTC)" "available:" "none" ;)
	@$(if $(OVERLAY_RUSTC_VERSION_MISSING),$(_ovl_line) "note: no rust $(OVERLAY_RUSTC_VERSION) built with gcc $(_ovl_rust_pool) (the gcc this build uses)" ;)
	@$(if $(OVERLAY_RUSTC_GCC_FALLBACK),$(_ovl_line) "note: none built with the gcc overlay: the vendor-gcc one is taken" ;)
endif

overlay-%:
	@$(MAKE) --no-print-directory overlay \
	    ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*))
