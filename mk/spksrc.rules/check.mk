###############################################################################
# spksrc.rules/check.mk
#
# make check / check-<arch>-<tcvers>: the capability gates an arch fails across the
# dependency tree. Included by supported.mk.
###############################################################################

# One walk of the tree. The grep is not redundant with the sed inside dependency-unsupported:
# stage0's bootstrap notice is an $(info) from the sub-make's PARSE, outside that pipe.
_gate_walk = DEPENDENCY_WALK=1 $(MAKE) --no-print-directory -s dependency-unsupported \
                 ARCH=$(ARCH) TCVERSION=$(TCVERSION) 2>/dev/null \
                 | grep -E '^(cross|driver|spk|diyspk|native|python|kernel)/'

# Package name in a column of its own, reason after it.
_gate_fmt  = awk '{ p = $$1 ; $$1 = "" ; printf "         %-26s %s\n", p, substr($$0, 2) }'

# Every capability gate in the dependency tree that this arch fails, or nothing when it
# builds. Pure diagnostic: reads the declared floors across the tree, extracts no toolchain.
#
# Required is the walk an arch context already defines; optional is what a second walk adds
# when OPTIONAL_DEPENDS are followed too. A set difference, not a label carried down the
# walk: a package under both a required and an optional parent is required.
#
# Then which of this package's own OPTIONAL_DEPENDS this arch ended up with: those that
# reached DEPENDS are in use, the rest are not. Read from the two variables, so it costs
# no third walk -- and it says out loud what a conditional dependency decided.
.PHONY: check
check: SHELL:=/bin/bash
check:  ## Report the capability gates ARCH/TCVERSION fails (see also check-<arch>-<vers>)
	@req=$$($(_gate_walk)) ; \
	all=$$(WALK_OPTIONAL_DEPENDS=1 $(_gate_walk)) ; \
	opt=$$(comm -13 <(echo "$$req") <(echo "$$all")) ; \
	if [ -z "$$req$$opt" ] ; then \
	   $(MSG) "$(NAME): $(ARCH)-$(TCVERSION) check: OK" ; \
	else \
	   $(MSG) "$(NAME): $(ARCH)-$(TCVERSION) check: $$(echo "$$req" | grep -c .) failed$$([ -n "$$opt" ] && echo ", $$(echo "$$opt" | grep -c .) more behind an optional dependency")" ; \
	   [ -z "$$req" ] || { echo "       required" ; echo "$$req" | $(_gate_fmt) ; } ; \
	   [ -z "$$opt" ] || { echo "       optional" ; echo "$$opt" | $(_gate_fmt) ; } ; \
	fi
	@$(if $(strip $(OPTIONAL_DEPENDS)),\
	   printf "       optional in use : %s\n" "$(or $(sort $(filter $(OPTIONAL_DEPENDS),$(DEPENDS))),-)" ; \
	   printf "       optional unused : %s\n" "$(or $(sort $(filter-out $(DEPENDS),$(OPTIONAL_DEPENDS))),-)" ,:)

# The goal-shaped form, for symmetry with arch-<arch>-<vers>. Carries the pair in the goal
# rather than in variables, so the parse it runs under has no ARCH to be refused for.
check-%:
	@$(MAKE) --no-print-directory check \
	    ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*))
