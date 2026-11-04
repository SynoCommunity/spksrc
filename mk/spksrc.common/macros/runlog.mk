###############################################################################
# spksrc.common/macros/runlog.mk
#
# Running a recipe's command under logging.
###############################################################################

# Macro: run a command, teeing its output into a log
#
#   @set -o pipefail ; $(call _runlog,$(MAKE) build-$*,build-$*.log) ; status=$$? ; ...
#
# Run $(1) under script(1) and tee everything into $(2), as a SHELL FRAGMENT usable
# inside a larger recipe line -- unlike RUNLOG it neither prefixes @ nor exits on
# failure, so the caller keeps its own status handling.
#
# script gives the command a pty, so its stdout AND stderr are teed: that is what puts a
# parse-time $(error), and make's own "*** ... Stop.", in the log. Setting LOGGING_ENABLED
# for the child makes this the only teeing level, so the inner RUNLOG stages take
# their pass-through branch and nothing is written twice.
define _runlog
if [ -z "$$LOGGING_ENABLED" ]; then \
    LOGGING_ENABLED=1 script -q -e -c "$(1)" /dev/null \
        | tee >(sed -r "s/\x1B\[[0-9;]*[mK]//g; s/\r//g" >> "$(2)") ; \
else \
    $(1) ; \
fi
endef

# Macro: run a make goal of this Makefile, logged
#
#   $(call RUNLOG,install)
#
# The goal-shaped facade over _runlog: builds the make command itself, writes to
# DEFAULT_LOG, and reports the failure. bash -o pipefail rather than `set -o pipefail`
# because these call sites keep the default /bin/sh -e as their SHELL.
define RUNLOG
@bash -o pipefail -c '$(call _runlog,$(MAKE) -f $(firstword $(MAKEFILE_LIST)) $(1),$(DEFAULT_LOG))' || { \
    $(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s - FAILED\n" \
        "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$(ARCH)-$(TCVERSION)" "$(1)") \
        | tee --append $(STATUS_LOG) ; \
    exit 1 ; \
}
endef
