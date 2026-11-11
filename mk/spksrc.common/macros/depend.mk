###############################################################################
# spksrc.common/macros/depend.mk
#
# Dependencies: declaring optional ones, and visiting each once in a walk.
###############################################################################

# Macro: a dependency the build takes when it can, with the switches that come with it
#
#   $(call depend,cross/vvenc,--enable-libvvenc)
#   $(call depend,cross/x265,--enable-libx265,--disable-libx265)
#   $(call depend,cross/intel-mediasdk,nop)
#   $(call depend,cross/libvmaf-2.3|cross/libvmaf-1.5,--enable-libvmaf)
#   $(call depend,cross/flac)
#   $(call depend,cross/libaom-latest|cross/libaom-3.8)
#
# With a second argument -- switches, or nop for none -- the dependency is optional: it is
# declared in OPTIONAL_DEPENDS, and spksrc.rules/depend.mk adds it to DEPENDS with $(2)
# only where its own tree supports the arch, else passes $(3). The condition lives in the
# dependency's floors, not in a copy here. Space-separated packages go together (all or
# none); | lists alternatives, the first supported wins.
#
# Without a second argument it is required: plain DEPENDS, or with | the first supported
# alternative -- the last one when none is, so the refusal names it. That is what a
# virtual package is.
#
# The call leaves a placeholder word (_odep_<n>_) in DEPENDS and CONFIGURE_ARGS, which
# depend.mk replaces once the verdicts are in: the outcome keeps the place of the call,
# as an ifeq at that line would.
depend = $(if $(strip $(2)),$(call _odepend,$(1),$(2),$(3)),$(if $(findstring |,$(1)),$(call _odepend,$(1),,,1),$(eval DEPENDS += $(1))))
define _odepend
$(eval _ODEP_N := $(words $(_ODEP_LIST) x))$(eval _ODEP_LIST += $(_ODEP_N))\
$(eval _ODEP_$(_ODEP_N)_PKGS := $(1))\
$(eval _ODEP_$(_ODEP_N)_ON := $(filter-out nop,$(2)))\
$(eval _ODEP_$(_ODEP_N)_OFF := $(filter-out nop,$(3)))\
$(eval _ODEP_$(_ODEP_N)_REQ := $(4))\
$(eval OPTIONAL_DEPENDS += $(subst |, ,$(1)))\
$(eval DEPENDS += _odep_$(_ODEP_N)_)$(eval CONFIGURE_ARGS += _odep_$(_ODEP_N)_)
endef

# Macro: visit each dependency once per walk
#
#   for depend in $(DEPENDS) ; do $(call dep_seen,$(STAMP_DIR),$$depend) && continue ; ... ; done
#
# Shell test for a recipe walking dependencies through sub-makes. True when $(2) was
# already visited in the walk whose stamps live in directory $(1); otherwise stamps it and
# is false. Each sub-make is a full parse, and a tree shares most of its nodes: without
# it gstreamer's plist walk visited zlib 132 times, for 67 distinct dependencies.
#
# The stamp is the dependency path with / -> __ (cross/zlib -> cross__zlib), created with
# mkdir so that two parallel visitors cannot both claim it. No $(1), or no such directory:
# always false, and every path is walked as before.
dep_seen = { [ -d "$(1)" ] && ! mkdir "$(1)/$$(echo $(2) | sed 's|/|__|g')" 2>/dev/null ; }
