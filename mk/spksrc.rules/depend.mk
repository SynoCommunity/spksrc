###############################################################################
# spksrc.rules/depend.mk
#
# Resolves the optional dependencies declared with $(call depend,<pkgs>,<switches>[,<else>])
# (spksrc.common/macros.mk): each goes to DEPENDS with its switches where its own tree
# supports ARCH-TCVERSION, and its <else> goes to CONFIGURE_ARGS where it does not.
#
# The verdict is the one `make check` gives: `dependency-unsupported` run in the
# dependency, its required tree included, empty when every gate is met. One sub-make per
# candidate, run in parallel once per WORK_DIR and kept in $(_ODEP_CACHE); every later
# parse into that WORK_DIR includes the file instead. Each walk runs in the dependency's
# own work-<arch>-<vers> -- the depth env-default.mk expects of a WORK_DIR to find the
# toolchain -- and with its own stamp directory: inherited from a parent make, one shared
# stamp directory would let a walk skip what another visited, and hide its gates.
#
# A dependency walk computes verdicts only for required alternatives (a|b with no switch,
# a virtual package): the tree it walks must hold the one that is picked. Optional ones it
# leaves out of DEPENDS unless a build already wrote the file, so the required walk the
# pre-check and `make check` run is the required tree. A verdict walk can resolve required
# alternatives below it in turn, down a tree without cycles. With no ARCH nothing is
# resolved, and OPTIONAL_DEPENDS alone carries them to dependency-list-spk.
#
# Included before pre-check.mk, so DEPENDS is complete before any rule reads it. Each
# outcome takes the place its call left in DEPENDS and CONFIGURE_ARGS, so the order is the
# order of the Makefile.
###############################################################################

ifneq ($(strip $(_ODEP_LIST)),)
ifneq ($(and $(ARCH),$(TCVERSION)),)

_ODEP_CACHE  = $(WORK_DIR)/depend-$(notdir $(CURDIR)).mk
_odep_var    = _ODEP_OK_$(subst /,__,$(1))
_ODEP_CANDS  = $(sort $(foreach n,$(_ODEP_LIST),$(subst |, ,$(_ODEP_$(n)_PKGS))))

-include $(_ODEP_CACHE)

_ODEP_REQ_CANDS = $(sort $(foreach n,$(_ODEP_LIST),$(if $(_ODEP_$(n)_REQ),$(subst |, ,$(_ODEP_$(n)_PKGS)))))
_ODEP_WANTED    = $(if $(filter 1,$(DEPENDENCY_WALK)),$(_ODEP_REQ_CANDS),$(_ODEP_CANDS))
_ODEP_MISSING   = $(strip $(foreach p,$(_ODEP_WANTED),$(if $(filter undefined,$(origin $(call _odep_var,$(p)))),$(p))))
ifneq ($(_ODEP_MISSING),)
# "<var> := 1" when the dependency's tree is clear, 0 when anything in it refuses the arch.
# Only verdict lines count: a toolchain bootstrap shares the walk's stdout.
_ODEP_NEW := $(shell mkdir -p $(WORK_DIR) && \
    printf '%s\n' $(_ODEP_MISSING) | xargs -P $$(nproc) -I{} sh -c ' \
      v=_ODEP_OK_$$(echo {} | sed "s|/|__|g") ; \
      out=$$(env -u RUN_ID -u DEP_FLAT_STAMP_DIR -u SPK_LIST_STAMP_DIR DEPENDENCY_WALK=1 \
                 $(MAKE) -s --no-print-directory -C $(BASEDIR)/{} dependency-unsupported \
                 ARCH=$(ARCH) TCVERSION=$(TCVERSION) WORK_DIR=$(BASEDIR)/{}/work-$(ARCH)-$(TCVERSION) 2>/dev/null \
             | grep -E "^(cross|spk|diyspk|native|kernel)/") ; \
      if [ -z "$$out" ] ; then echo "$$v~:=~1" ; else echo "$$v~:=~0" ; fi' | sort)
$(foreach l,$(_ODEP_NEW),$(eval $(subst ~, ,$(l))))
$(shell printf '%s\n' $(subst ~, ,$(foreach l,$(_ODEP_NEW),'$(l)')) >> $(_ODEP_CACHE))
endif

# A group (space-separated) resolves when every member has a supported alternative (|-separated).
_odep_pick = $(firstword $(foreach a,$(subst |, ,$(1)),$(if $(filter 1,$($(call _odep_var,$(a)))),$(a))))
_odep_take = $(strip $(foreach g,$(1),$(call _odep_pick,$(g))))
# Required: the first supported alternative, else the last, which the walk then refuses.
_odep_must = $(strip $(foreach g,$(1),$(or $(call _odep_pick,$(g)),$(lastword $(subst |, ,$(g))))))

# What each call resolves to: _ODEP_<n>_DEP for DEPENDS, _ODEP_<n>_ARG for CONFIGURE_ARGS.
$(foreach n,$(_ODEP_LIST),\
  $(if $(_ODEP_$(n)_REQ),\
    $(eval _ODEP_$(n)_DEP := $(call _odep_must,$(_ODEP_$(n)_PKGS))),\
  $(if $(filter $(words $(_ODEP_$(n)_PKGS)),$(words $(call _odep_take,$(_ODEP_$(n)_PKGS)))),\
    $(eval _ODEP_$(n)_DEP := $(call _odep_take,$(_ODEP_$(n)_PKGS)))$(eval _ODEP_$(n)_ARG := $(_ODEP_$(n)_ON)),\
    $(eval _ODEP_$(n)_ARG := $(_ODEP_$(n)_OFF)))))

endif

# Each call left _odep_<n>_ where it stood; put its outcome there, or nothing (no ARCH, or
# an optional dependency a walk does not resolve). Done in every case, so no placeholder
# ever reaches a recipe or a walk. On the unexpanded text, reassigned recursively: a
# $(VAR) in CONFIGURE_ARGS still expands when read, after the includes that define it.
_ODEP_RAW_DEPENDS        := $(value DEPENDS)
_ODEP_RAW_CONFIGURE_ARGS := $(value CONFIGURE_ARGS)
$(foreach n,$(_ODEP_LIST),\
  $(eval _ODEP_RAW_DEPENDS        := $$(subst _odep_$(n)_,$$(_ODEP_$(n)_DEP),$$(_ODEP_RAW_DEPENDS)))\
  $(eval _ODEP_RAW_CONFIGURE_ARGS := $$(subst _odep_$(n)_,$$(_ODEP_$(n)_ARG),$$(_ODEP_RAW_CONFIGURE_ARGS))))
$(eval DEPENDS = $(_ODEP_RAW_DEPENDS))
$(eval CONFIGURE_ARGS = $(_ODEP_RAW_CONFIGURE_ARGS))

endif
