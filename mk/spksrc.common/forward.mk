###############################################################################
# spksrc.common/forward.mk
#
# The build-wide switches, and the one shape every process boundary needs them in.
#
# Variables:
#  FWRD_VARS : names of the switches to carry, appended beside each declaration
#  FWRD_ARGS : those names as NAME='value' pairs, for a sub-make or an env -i
###############################################################################

# sort, and not merely to order: some packages include spksrc.common.mk themselves and
# then reach it again through spksrc.spk-meta.mk, so a bare += would list each name twice.
FWRD_VARS := $(sort $(FWRD_VARS))

# As command-line variables: the only form that outranks a makefile assignment in the
# child, and that a sub-make passes on to its own children through MAKEFLAGS.
# Lazy (=): a switch may still be assigned after this file is read.
FWRD_ARGS = $(foreach v,$(FWRD_VARS),$(v)='$($(v))')
