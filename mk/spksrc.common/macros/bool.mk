###############################################################################
# spksrc.common/macros/bool.mk
#
# Boolean switches.
###############################################################################

_TRUE_VALUES  := 1 y yes true on
_FALSE_VALUES := 0 n no false off
_lower = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$(1)))))))))))))))))))))))))))

# Macro: read a boolean switch
#
#   ACTIVE = $(if $(call is_true,$(OVERLAY_GCC)),1)
#   ifeq ($(call bool,$(OVERLAY_GCC),OVERLAY_GCC),TRUE)
#   $(call assert_bool,$(OVERLAY_GCC),OVERLAY_GCC)
#
# A switch may be written 1/0, y/n, yes/no, true/false or on/off, in any case; empty is
# false, so an unset switch is off. is_true and is_false return a non-empty word or nothing,
# for $(if); bool returns TRUE or FALSE, for ifeq. assert_bool and bool stop the build on any
# other value, naming the variable when given one: a typo must not read as "off".
is_true  = $(filter $(_TRUE_VALUES),$(call _lower,$(strip $(1))))
is_false = $(or $(filter $(_FALSE_VALUES),$(call _lower,$(strip $(1)))),$(if $(strip $(1)),,1))
define assert_bool
$(if $(or $(call is_true,$(1)),$(call is_false,$(1))),,$(error \
  $(if $(2),$(2): )invalid boolean value '$(strip $(1))' -- expected one of: $(_TRUE_VALUES) $(_FALSE_VALUES)))
endef
bool = $(call assert_bool,$(1),$(2))$(if $(call is_true,$(1)),TRUE,FALSE)
