# Standardized boolean parsing helper
#
# This file provides consistent boolean evaluation across the build system.
# It normalizes various boolean representations (yes/no, true/false, 1/0, y/n)
# into a consistent format for Make conditionals.
#
# Usage:
#   include ../../mk/spksrc.bool.mk
#   ifeq ($(call bool,$(MY_VAR)),true)
#     # do something when MY_VAR is truthy
#   endif
#
# Truthy values: yes, true, 1, y, YES, TRUE, Y (case insensitive)
# Falsy values:  no, false, 0, n, NO, FALSE, N, empty (case insensitive)
#

# Convert any boolean-like value to lowercase 'true' or 'false'
# Empty values are considered false
define bool
$(strip \
  $(if $(1), \
    $(if $(filter yes YES Yes true TRUE True 1 y Y,$(1)),true,false), \
    false))
endef

# Check if a value is truthy
# Returns non-empty string if true, empty if false
define is_true
$(strip $(filter true,$(call bool,$(1))))
endef

# Check if a value is falsy
# Returns non-empty string if false, empty if true
define is_false
$(strip $(if $(call is_true,$(1)),,false))
endef
