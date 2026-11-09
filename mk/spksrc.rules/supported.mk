###############################################################################
# spksrc.rules/supported.mk
#
# Architecture / version support gating; provides the build-arch-* and
# *-supported targets used to iterate buildable archs for a package, and
# includes the check and overlay diagnostics (check.mk, overlay.mk).
###############################################################################

### Include common rules
include ../../mk/spksrc.rules.mk

### The check and overlay diagnostics
include ../../mk/spksrc.rules/check.mk
include ../../mk/spksrc.rules/overlay.mk


###

# make all-supported
ifeq (supported,$(findstring supported,$(subst -, ,$(firstword $(MAKECMDGOALS)))))
TARGET_TYPE = supported
ifeq ($(ARCH),noarch)
TARGET_ARCH = $(addprefix noarch-,$(sort $(foreach version,$(SUPPORTED_ARCHS),$(word 2,$(subst -, ,$(version))))))
else
TARGET_ARCH = $(SUPPORTED_ARCHS)
endif

# make all-latest
else ifeq (latest,$(findstring latest,$(subst -, ,$(firstword $(MAKECMDGOALS)))))
TARGET_TYPE = latest
ifeq ($(ARCH),noarch)
TARGET_ARCH = $(addprefix noarch-,$(sort $(foreach version,$(LATEST_ARCHS),$(word 2,$(subst -, ,$(version))))))
else
TARGET_ARCH = $(LATEST_ARCHS)
endif
endif

# error: make setup not invoked
ifneq ($(strip $(TARGET_TYPE)),)
ifeq ($(strip $(SUPPORTED_ARCHS)),)
TARGET_ARCH = error
endif
endif

####

.PHONY: supported-arch-error

$(ACTION)$(TARGET_TYPE)-arch-error:
	@$(MSG) ########################################################
	@$(MSG) ERROR - Please run make setup from spksrc root directory
	@$(MSG) ########################################################

###

.PHONY: all-$(TARGET_TYPE) pre-build-native

all-$(TARGET_TYPE): $(addprefix $(TARGET_TYPE)-arch-,$(TARGET_ARCH))

pre-build-native: SHELL:=/bin/bash
pre-build-native:
	@set -o pipefail; { \
	   $(MSG) Pre-build native dependencies for parallel build [START] ; \
	   env $(ENV) $(MAKE) native-depend ; \
	   $(MSG) Pre-build native dependencies for parallel build [END] ; \
	} ; [ $${PIPESTATUS[0]} -eq 0 ] || false

# Per-package, so out of FWRD_VARS, which crosses into other packages. Passed only when
# set: an empty argument would override the child's own assignment.
DBG_ARGS = $(if $(strip $(GCC_DEBUG_INFO)),GCC_DEBUG_INFO='$(GCC_DEBUG_INFO)')

$(TARGET_TYPE)-arch-% &: pre-build-native
	-@MAKEFLAGS= $(MAKE) $(FWRD_ARGS) $(DBG_ARGS) arch-$*

# Teed here rather than in build-arch-%: one level up also catches make's own
# "*** [build-arch-...] Error 1" cascade, which is emitted after that recipe exits.
# _runlog's LOGGING_ENABLED guard makes this the only teeing level.
#
# pre-build-native for the reason $(TARGET_TYPE)-arch-% carries it: naming more than one
# goal on a command line -- make -j2 arch-x64-7.2 arch-dakota-1.3 -- forks a walk per goal,
# and nothing below stops two of them entering the same native/<pkg> at once. depend_target
# walks native/% without the dep_seen guard its other two loops use, and that guard would
# not help here anyway: DEPEND_SEEN is $(WORK_DIR)/.DEPEND, one per spk work dir, so two
# arch goals never share one. A prerequisite is built once per invocation, so the pass runs
# once ahead of both forks, and a single-arch build pays nothing for it -- with the natives
# in place native-depend has nothing to do.
arch-%: SHELL:=/bin/bash
arch-%: pre-build-native
	@set -o pipefail ; \
	$(call _runlog,$(PSTAT_TIME) $(MAKE) $(addprefix build-arch-, $(or $(filter $(addprefix %, $(DEFAULT_TC)), $(filter %$(word 2,$(subst -, ,$*)), $(filter $(firstword $(subst -, ,$*))%, $(AVAILABLE_TOOLCHAINS)))),$*)),build-$*.log)

arch-noarch-%: SHELL:=/bin/bash
arch-noarch-%: pre-build-native
	@set -o pipefail ; \
	$(call _runlog,$(PSTAT_TIME) $(MAKE) $(addprefix build-noarch-, $(filter $*, $(AVAILABLE_TCVERSIONS) 3.1)),build-noarch-$*.log)

####

build-arch-%: SHELL:=/bin/bash
build-arch-%: 
	@$(MSG) BUILDING package for arch $* with SynoCommunity toolchain 
	@$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s [BEGIN]\n" \
	        "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$*" "$(NAME)") \
	        | tee --append $(STATUS_LOG)
	@# What the build starts with, at the head of its log: its overlays, with its switches,
	@# then the gates it fails. Informational: a report that fails does not fail the build.
	@$(MSG) "$(_ovl_rule)"
	@MAKEFLAGS= $(MAKE) --no-print-directory $(FWRD_ARGS) \
	    ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)) overlay || :
	@$(MSG) "$(_ovl_rule)"
	@MAKEFLAGS= $(MAKE) --no-print-directory $(FWRD_ARGS) \
	    ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)) check || :
	@$(MSG) "$(_ovl_rule)"
	@# pipefail: _runlog ends in a pipeline, so without it $$? would be tee's, and a
	@# failed build would be reported as a success.
	@set -o pipefail ; \
	$(call _runlog,MAKEFLAGS= $(MAKE) $(FWRD_ARGS) $(DBG_ARGS) ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)),build-$*.log) ; \
	status=$$? ; \
	$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s [END]\n" \
	       "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$*" "$(NAME)") \
	       | tee --append $(STATUS_LOG) ; \
	[ $$status -eq 0 ] || false

build-noarch-%: SHELL:=/bin/bash
build-noarch-%: 
	@$(MSG) BUILDING noarch package for TCVERSION $* 
	@$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, TCVERSION: %s, NAME: %s [BEGIN]\n" \
	       "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$*" "$(NAME)") \
	       | tee --append $(STATUS_LOG)
	@set -o pipefail ; \
	$(call _runlog,MAKEFLAGS= $(MAKE) $(FWRD_ARGS) $(DBG_ARGS) TCVERSION=$* ARCH=noarch,build-noarch-$*.log) ; \
	status=$$? ; \
	$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, TCVERSION: %s, NAME: %s [END]\n" \
	       "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$*" "$(NAME)") \
	       | tee --append $(STATUS_LOG) ; \
	[ $$status -eq 0 ] || false

####
