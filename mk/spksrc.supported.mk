####

# make all-supported
ifeq (supported,$(subst all-,,$(firstword $(MAKECMDGOALS))))
TARGET_TYPE = supported
TARGET_ARCH = $(SUPPORTED_ARCHS)

# make all-latest
else ifeq (latest,$(subst all-,,$(firstword $(MAKECMDGOALS))))
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

.PHONY: all-$(TARGET_TYPE) pre-build-native

all-$(TARGET_TYPE): $(addprefix $(TARGET_TYPE)-arch-,$(TARGET_ARCH))

pre-build-native: SHELL:=/bin/bash
pre-build-native:
	@$(MSG) $$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: native, NAME: n/a [BEGIN] > $(PSTAT_LOG)
	@$(MSG) Pre-build native dependencies for parallel build [START]
	@for depend in $$($(MAKE) dependency-list) ; \
	do \
	  if [ "$${depend%/*}" = "native" ]; then \
	    $(MSG) "Pre-processing $${depend}" ; \
	    $(MSG) "  env $(ENV) $(MAKE) -C ../../$$depend" ; \
	    env $(ENV) $(MAKE) -C ../../$$depend 2>&1 | tee --append build-$${depend%/*}-$${depend#*/}.log ; \
	    [ $${PIPESTATUS[0]} -eq 0 ] || false ; \
	  fi ; \
	done ; \
	$(MSG) Pre-build native dependencies for parallel build [END] ; \
	$(MSG) $$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: native, NAME: n/a [END] >> $(PSTAT_LOG)
	@$(MSG) PROCESSING archs $(TARGET_ARCH)

.PHONY: supported-arch-error
$(TARGET_TYPE)-arch-error:
	@$(MSG) ########################################################
	@$(MSG) ERROR - Please run make setup from spksrc root directory
	@$(MSG) ########################################################

$(TARGET_TYPE)-arch-% &: pre-build-native
	@$(MSG) BUILDING package for arch $* with SynoCommunity toolchain
	-@MAKEFLAGS= $(PSTAT_TIME) $(MAKE) arch-$* 2>&1 | tee --append build-$*.log

arch-%:
	@$(MSG) Building package for arch $(or $(filter $(addprefix %, $(DEFAULT_TC)), $(filter %$(word 2,$(subst -, ,$*)), $(filter $(firstword $(subst -, ,$*))%, $(AVAILABLE_TOOLCHAINS)))), $*)
	$(MAKE) $(addprefix build-arch-, $(or $(filter $(addprefix %, $(DEFAULT_TC)), $(filter %$(word 2,$(subst -, ,$*)), $(filter $(firstword $(subst -, ,$*))%, $(AVAILABLE_TOOLCHAINS)))),$*))

build-arch-%: SHELL:=/bin/bash
build-arch-%: 
	@$(MSG) Building package for arch $*
	@$(MSG) $$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $*, NAME: $(NAME) [BEGIN] >> $(PSTAT_LOG)
	@MAKEFLAGS= $(PSTAT_TIME) $(MAKE) ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)) 2>&1 | tee --append build-$*.log ; \
	status=$${PIPESTATUS[0]} ; \
	$(MSG) $$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $*, NAME: $(NAME) [END] >> $(PSTAT_LOG) ; \
	[ $${status[0]} -eq 0 ] || false

####
