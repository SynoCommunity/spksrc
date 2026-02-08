####

### Include common rules
include ../../mk/spksrc.common-rules.mk


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
	-@MAKEFLAGS= GCC_DEBUG_INFO="$(GCC_DEBUG_INFO)" $(MAKE) arch-$*

arch-%:
	@$(PSTAT_TIME) $(MAKE) $(addprefix build-arch-, $(or $(filter $(addprefix %, $(DEFAULT_TC)), $(filter %$(word 2,$(subst -, ,$*)), $(filter $(firstword $(subst -, ,$*))%, $(AVAILABLE_TOOLCHAINS)))),$*))

arch-noarch-%:
	@$(PSTAT_TIME) $(MAKE) $(addprefix build-noarch-, $(filter $*, $(AVAILABLE_TCVERSIONS) 3.1))

####

build-arch-%: SHELL:=/bin/bash
build-arch-%: 
	@$(MSG) BUILDING package for arch $* with SynoCommunity toolchain | tee --append build-$*.log
	@$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s [BEGIN]\n" \
	        "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$*" "$(NAME)") \
	        | tee --append $(STATUS_LOG)
	@MAKEFLAGS= GCC_DEBUG_INFO="$(GCC_DEBUG_INFO)" $(MAKE) ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)) 2>&1 ; \
	status=$${PIPESTATUS[0]} ; \
	$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s [END]\n" \
	       "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$*" "$(NAME)") \
	       | tee --append $(STATUS_LOG) ; \
	[ $${status[0]} -eq 0 ] || false

build-noarch-%: SHELL:=/bin/bash
build-noarch-%: 
	@$(MSG) BUILDING noarch package for TCVERSION $* | tee --append build-noarch-$*.log
	@$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, TCVERSION: %s, NAME: %s [BEGIN]\n" \
	       "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$*" "$(NAME)") \
	       | tee --append $(STATUS_LOG)
	@MAKEFLAGS= $(MAKE) TCVERSION=$* ARCH=noarch 2>&1 ; \
	status=$${PIPESTATUS[0]} ; \
	$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, TCVERSION: %s, NAME: %s [END]\n" \
	       "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$*" "$(NAME)") \
	       | tee --append $(STATUS_LOG) ; \
	[ $${status[0]} -eq 0 ] || false

####
