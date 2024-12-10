####

### Include common rules
include ../../mk/spksrc.common-rules.mk


###

# make all-supported
ifeq (supported,$(findstring supported,$(subst -, ,$(firstword $(MAKECMDGOALS)))))
TARGET_TYPE = supported
TARGET_ARCH = $(SUPPORTED_ARCHS)

# make all-latest
else ifeq (latest,$(findstring latest,$(subst -, ,$(firstword $(MAKECMDGOALS)))))
TARGET_TYPE = latest
TARGET_ARCH = $(LATEST_ARCHS)
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
	@$(MSG) $$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: native, NAME: n/a [BEGIN] >> $(PSTAT_LOG)
	@$(MSG) Pre-build native dependencies for parallel build [START]
	@for depend in $$($(MAKE) dependency-list) ; \
	do \
	  if [ "$${depend%/*}" = "native" ]; then \
	    $(MSG) "Pre-processing $${depend}" | tee --append build-$${depend%/*}-$${depend#*/}.log ; \
	    $(MSG) "  env $(ENV) $(MAKE) -C ../../$$depend" | tee --append build-$${depend%/*}-$${depend#*/}.log ; \
	    env $(ENV) $(MAKE) -C ../../$$depend 2>&1 | tee --append build-$${depend%/*}-$${depend#*/}.log ; \
	    [ $${PIPESTATUS[0]} -eq 0 ] || false ; \
	  fi ; \
	done ; \
	$(MSG) Pre-build native dependencies for parallel build [END] ; \
	$(MSG) $$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: native, NAME: n/a [END] >> $(PSTAT_LOG)
	@$(MSG) PROCESSING archs $(TARGET_ARCH)

$(TARGET_TYPE)-arch-% &: pre-build-native
	-@MAKEFLAGS= GCC_DEBUG_INFO="$(GCC_DEBUG_INFO)" $(MAKE) arch-$*

arch-%:
	$(PSTAT_TIME) $(MAKE) $(addprefix build-arch-, $(or $(filter $(addprefix %, $(DEFAULT_TC)), $(filter %$(word 2,$(subst -, ,$*)), $(filter $(firstword $(subst -, ,$*))%, $(AVAILABLE_TOOLCHAINS)))),$*)) | tee --append build-$*.log

noarch-%:
	$(PSTAT_TIME) $(MAKE) $(addprefix build-noarch-, $(filter $*, $(AVAILABLE_TCVERSIONS) 3.1)) | tee --append build-$@.log

####

build-arch-%: SHELL:=/bin/bash
build-arch-%: 
	@$(MSG) BUILDING package for arch $* with SynoCommunity toolchain
	@$(MSG) $$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $*, NAME: $(NAME) [BEGIN] >> $(PSTAT_LOG)
	@MAKEFLAGS= GCC_DEBUG_INFO="$(GCC_DEBUG_INFO)" $(MAKE) ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)) 2>&1 ; \
	status=$${PIPESTATUS[0]} ; \
	$(MSG) $$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $*, NAME: $(NAME) [END] >> $(PSTAT_LOG) ; \
	[ $${status[0]} -eq 0 ] || false

build-noarch-%: SHELL:=/bin/bash
build-noarch-%: 
	@$(MSG) BUILDING noarch package for TCVERSION $*
	@MAKEFLAGS= $(MAKE) TCVERSION=$* 2>&1 ; \
	status=$${PIPESTATUS[0]} ; \
	$(MSG) $$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), TCVERSION: $*, NAME: $(NAME) [END] >> $(PSTAT_LOG) ; \
	[ $${status[0]} -eq 0 ] || false

####
