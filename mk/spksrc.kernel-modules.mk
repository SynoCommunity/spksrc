####

kernel-modules-%: SHELL:=/bin/bash
kernel-modules-%:
	@if [ "$(filter $(DEFAULT_TC),lastword $(subst -, ,$(MAKECMDGOALS)))" ]; then \
	   archs2process="$(filter $(addprefix %-,$(SUPPORTED_KERNEL_VERSIONS)),$(filter $(addsuffix -$(word 1,$(subst ., ,$(word 2,$(subst -, ,$*))))%,$(shell sed -n -e '/TC_ARCH/ s/.*= *//p' ../../toolchain/syno-$*/Makefile)), $(LEGACY_ARCHS)))" ; \
	elif [ "$(filter $(GENERIC_ARCHS),$(subst -, ,$(MAKECMDGOALS)))" ]; then \
	   archs2process="$(filter $(addprefix %-,$(lastword $(subst -, ,$(MAKECMDGOALS)))),$(filter $(addsuffix -$(word 1,$(subst ., ,$(word 2,$(subst -, ,$*))))%,$(filter-out $(UNSUPPORTED_ARCHS),$(shell sed -n -e '/TC_ARCH/ s/.*= *//p' ../../toolchain/syno-$*/Makefile))), $(LEGACY_ARCHS)))" ; \
	else \
	   archs2process=$* ; \
	fi ; \
	$(MSG) ARCH to be processed: $${archs2process} ; \
	set -e ; \
	for arch in $${archs2process} ; do \
	  $(MSG) "Processing $${arch} ARCH" ; \
	  echo " ************** kernel-modules-$* **************** " ; \
	  echo "REQUIRE_KERNEL: [$(REQUIRE_KERNEL)]" ; \
	  echo "REQUIRE_KERNEL_MODULE: [$(REQUIRE_KERNEL_MODULE)]" ; \
	  echo "KERNEL_ROOT: [$(KERNEL_ROOT)]" ; \
	  echo "DEPENDS: [$(DEPENDS)]" ; \
	  MAKEFLAGS= $(PSTAT_TIME) $(MAKE) WORK_DIR=$(CURDIR)/work-$* ARCH=$$(echo $${arch} | cut -f1 -d-) TCVERSION=$$(echo $${arch} | cut -f2 -d-) strip 2>&1 | tee --append build-$*-kernel-modules.log ; \
	  [ $${PIPESTATUS[0]} -eq 0 ] || false ; \
	  $(MAKE) spkclean ; \
	  if [ "$$(basename $(abspath $(CURDIR)/$(BASEDIR)))" = "workspace" ]; then \
	     rm -fr $(CURDIR)/work-$*/$(addprefix linux-, $${arch}) ; \
	     $(MAKE) -C ../../toolchain/syno-$${arch} clean ; \
	  fi ; \
	done

kernel-arch-%:
	$(MAKE) $(addprefix kernel-modules-, $(or $(filter $(addprefix %, $(DEFAULT_TC)), $(filter %$(word 2,$(subst -, ,$*)), $(filter $(firstword $(subst -, ,$*))%, $(AVAILABLE_TOOLCHAINS)))),$*))
	$(MAKE) REQUIRE_KERNEL_MODULE= REQUIRE_KERNEL= WORK_DIR=$(CURDIR)/work-$* $(addprefix build-arch-, $*)
