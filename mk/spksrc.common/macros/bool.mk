###############################################################################
# spksrc.common/macros/bool.mk
#
# Boolean switches.
###############################################################################

# Macro: the values a switch may take
#
#   ifneq ($(filter $(OVERLAY_GCC),$(TRUE)),)
#
# Every spelling, in lower and upper case. A mixed-case one (On, True) is not listed:
# is_true and is_false lower-case the value before they look it up.
TRUE  := 1 y yes true on
TRUE  += $(filter-out $(TRUE),$(call upper,$(TRUE)))
FALSE := 0 n no false off
FALSE += $(filter-out $(FALSE),$(call upper,$(FALSE)))

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
is_true  = $(filter $(TRUE),$(call lower,$(strip $(1))))
is_false = $(or $(filter $(FALSE),$(call lower,$(strip $(1)))),$(if $(strip $(1)),,1))
define assert_bool
$(if $(or $(call is_true,$(1)),$(call is_false,$(1))),,$(error \
  $(if $(2),$(2): )invalid boolean value '$(strip $(1))' -- expected one of, in any case: $(call uniq,$(call lower,$(TRUE) $(FALSE)))))
endef
bool = $(call assert_bool,$(1),$(2))$(if $(call is_true,$(1)),TRUE,FALSE)
