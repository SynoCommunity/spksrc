###

KERNEL_REQUIRED = $(MAKE) kernel-required
ifeq ($(strip $(KERNEL_REQUIRED)),)
ALL_ACTION = $(sort $(basename $(subst -,.,$(basename $(subst .,,$(ARCHS_WITH_KERNEL_SUPPORT))))))
endif

#### used as subroutine to test whether any dependency has REQUIRE_KERNEL defined

.PHONY: kernel-required
kernel-required:
	@if [ -n "$(REQUIRE_KERNEL)" -o -n "$(REQUIRE_KERNEL_MODULE)" ]; then \
	  exit 1 ; \
	fi
	@for depend in $(BUILD_DEPENDS) $(DEPENDS) ; do \
	  if $(MAKE) --no-print-directory -C ../../$$depend kernel-required >/dev/null 2>&1 ; then \
	    exit 0 ; \
	  else \
	    exit 1 ; \
	  fi ; \
	done

####

kernel-modules-%: SHELL:=/bin/bash
kernel-modules-%:
	@if [ "$(filter $(DEFAULT_TC),lastword $(subst -, ,$(MAKECMDGOALS)))" ]; then \
	   archs2process="$(filter $(addprefix %-,$(SUPPORTED_KERNEL_VERSIONS)),$(filter $(addsuffix -$(word 1,$(subst ., ,$(word 2,$(subst -, ,$*))))%,$(shell sed -n -e '/TC_ARCH/ s/.*= *//p' ../../toolchain/syno-$*/Makefile)), $(LEGACY_ARCHS)))" ; \
	elif [ "$(filter $(GENERIC_ARCHS),$(subst -, ,$(MAKECMDGOALS)))" ]; then \
	   archs2process="$(filter $(addprefix %-,$(lastword $(subst -, ,$(MAKECMDGOALS)))),$(filter $(addsuffix -$(word 1,$(subst ., ,$(word 2,$(subst -, ,$*))))%,$(shell sed -n -e '/TC_ARCH/ s/.*= *//p' ../../toolchain/syno-$*/Makefile)), $(LEGACY_ARCHS)))" ; \
	else \
	   archs2process=$* ; \
	fi ; \
	$(MSG) ARCH to be processed: $${archs2process} ; \
	set -e ; \
	for arch in $${archs2process} ; do \
	  $(MSG) "Processing $${arch} ARCH" ; \
	  MAKEFLAGS= $(PSTAT_TIME) $(MAKE) WORK_DIR=$(PWD)/work-$* ARCH=$$(echo $${arch} | cut -f1 -d-) TCVERSION=$$(echo $${arch} | cut -f2 -d-) strip 2>&1 | tee --append build-$*-kernel-modules.log ; \
	  [ $${PIPESTATUS[0]} -eq 0 ] || false ; \
	  $(MAKE) spkclean ; \
	  rm -fr $(PWD)/work-$*/$(addprefix linux-, $${arch}) ; \
	  $(MAKE) -C ../../toolchain/syno-$${arch} clean ; \
	done

kernel-arch-%:
	$(MAKE) $(addprefix kernel-modules-, $(or $(filter $(addprefix %, $(DEFAULT_TC)), $(filter %$(word 2,$(subst -, ,$*)), $(filter $(firstword $(subst -, ,$*))%, $(AVAILABLE_TOOLCHAINS)))),$*))
	$(MAKE) REQUIRE_KERNEL_MODULE= REQUIRE_KERNEL= WORK_DIR=$(PWD)/work-$* $(addprefix build-arch-, $*)
