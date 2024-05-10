####

# kernel arch definitions
include $(BASEDIR)mk/spksrc.kernel-env.mk

###

kernel-modules:
	@set -e; \
	rsync -ah --mkpath work$(ARCH_SUFFIX)/tc_vars* work$(ARCH_SUFFIX)/tc_vars-backup ; \
	for depend in $(KERNEL_DEPEND); \
	do                          \
	  $(MSG) "Building kernel-modules for $${depend} ARCH" | tee --append build-$(ARCH)-$(TCVERSION)-kernel-modules-$${depend}.log ; \
	  $(MAKE) spkclean ; \
	  $(MSG) "$$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $(ARCH)-$(TCVERSION), NAME: kernel-modules-$${depend}-$(TCVERSION) [BEGIN]" >> $(PSTAT_LOG) ; \
	  $(PSTAT_TIME) $(MAKE) WORK_DIR=$(CURDIR)/work$(ARCH_SUFFIX) \
	          REQUIRE_KERNEL_MODULE="$(REQUIRE_KERNEL_MODULE)" \
	          ARCH=$$(echo $${depend} | cut -f1 -d-) \
	          TCVERSION=$$(echo $${depend} | cut -f2 -d-) \
	          -C ../../kernel/syno-$$depend | tee --append build-$(ARCH)-$(TCVERSION)-kernel-modules-$${depend}.log ; \
	  $(MSG) "$$(date +%Y%m%d-%H%M%S) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $(ARCH)-$(TCVERSION), NAME: kernel-modules-$${depend}-$(TCVERSION) [END]" >> $(PSTAT_LOG) ; \
	done ; \
	rsync -ah work$(ARCH_SUFFIX)/tc_vars-backup/tc_vars* work$(ARCH_SUFFIX)/.

kernel-arch-%:
	$(MAKE) $(addprefix kernel-modules-, $(or $(filter $(addprefix %, $(DEFAULT_TC)), $(filter %$(word 2,$(subst -, ,$*)), $(filter $(firstword $(subst -, ,$*))%, $(AVAILABLE_TOOLCHAINS)))),$*)) | tee --append build-$*.log
