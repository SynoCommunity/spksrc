###############################################################################
# spksrc.rules/supported.mk
#
# Architecture / version support gating; provides the build-arch-* and
# *-supported targets used to iterate buildable archs for a package.
###############################################################################

### Include common rules
include ../../mk/spksrc.rules.mk


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

$(TARGET_TYPE)-arch-% &: pre-build-native
	-@MAKEFLAGS= GCC_DEBUG_INFO="$(GCC_DEBUG_INFO)" $(MAKE) $(OVERLAY_SELECTORS) arch-$*

# Teed here rather than in build-arch-%: one level up also catches make's own
# "*** [build-arch-...] Error 1" cascade, which is emitted after that recipe exits.
# _runlog's LOGGING_ENABLED guard makes this the only teeing level.
arch-%: SHELL:=/bin/bash
arch-%:
	@set -o pipefail ; \
	$(call _runlog,$(PSTAT_TIME) $(MAKE) $(addprefix build-arch-, $(or $(filter $(addprefix %, $(DEFAULT_TC)), $(filter %$(word 2,$(subst -, ,$*)), $(filter $(firstword $(subst -, ,$*))%, $(AVAILABLE_TOOLCHAINS)))),$*)),build-$*.log)

arch-noarch-%: SHELL:=/bin/bash
arch-noarch-%:
	@set -o pipefail ; \
	$(call _runlog,$(PSTAT_TIME) $(MAKE) $(addprefix build-noarch-, $(filter $*, $(AVAILABLE_TCVERSIONS) 3.1)),build-noarch-$*.log)

####

build-arch-%: SHELL:=/bin/bash
build-arch-%: 
	@$(MSG) BUILDING package for arch $* with SynoCommunity toolchain 
	@$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s [BEGIN]\n" \
	        "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$*" "$(NAME)") \
	        | tee --append $(STATUS_LOG)
	@# pipefail: _runlog ends in a pipeline, so without it $$? would be tee's, and a
	@# failed build would be reported as a success.
	@set -o pipefail ; \
	$(call _runlog,MAKEFLAGS= GCC_DEBUG_INFO=$(GCC_DEBUG_INFO) $(MAKE) $(OVERLAY_SELECTORS) ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)),build-$*.log) ; \
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
	$(call _runlog,MAKEFLAGS= $(MAKE) $(OVERLAY_SELECTORS) TCVERSION=$* ARCH=noarch,build-noarch-$*.log) ; \
	status=$$? ; \
	$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, TCVERSION: %s, NAME: %s [END]\n" \
	       "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$*" "$(NAME)") \
	       | tee --append $(STATUS_LOG) ; \
	[ $$status -eq 0 ] || false

####
