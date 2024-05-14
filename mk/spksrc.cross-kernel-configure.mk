### Configure rules
#   Prepare the kernel sources to match target version and be ready for latest steps.
# Targets are executed in the following order:
#  kernel_configure_msg_target
#  pre_kernel_configure_target    (override with PRE_KERNEL_CONFIGURE_TARGET)
#  kernel_configure_target        (override with KERNEL_CONFIGURE_TARGET)
#  post_kernel_configure_target   (override with POST_KERNEL_CONFIGURE_TARGET)
# Variables:
#  KERNEL_CONFIGURE_ARGS   Currently unused, may be used at a later time
#  KERNEL_ARCH             Kernel arch as define in kernel/syno-<arch>-<version>/Makefile
#  KERNEL_BASE_ARCH        Default kernel source arch directory
#  KERNEL_CONFIG           Actual kernel configuration to use to build modules from
#  NAME                    Refers to $(KERNEL_NAME) being syno-$(KERNEL_ARCH)-$(KERNEL_VERS)
#  TC_KERNEL               Exact kernel version as provided by toolchain configuration $(WORK_DIR)/tc_vars.mk
#  TC_PATH                 Arch toolchain path as provided in $(WORK_DIR)/tc_vars.mk
#  TC_PREFIX               Arch triplet bineg used as prefix for toolchain compilers & tools

KERNEL_CONFIGURE_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)kernel_configure_done

ifeq ($(strip $(PRE_KERNEL_CONFIGURE_TARGET)),)
PRE_KERNEL_CONFIGURE_TARGET = pre_kernel_configure_target
else
$(PRE_KERNEL_CONFIGURE_TARGET): kernel_configure_msg
endif
ifeq ($(strip $(KERNEL_CONFIGURE_TARGET)),)
KERNEL_CONFIGURE_TARGET = kernel_configure_target
else
$(KERNEL_CONFIGURE_TARGET): $(PRE_KERNEL_CONFIGURE_TARGET)
endif
ifeq ($(strip $(POST_KERNEL_CONFIGURE_TARGET)),)
POST_KERNEL_CONFIGURE_TARGET = post_kernel_configure_target
else
$(POST_KERNEL_CONFIGURE_TARGET): $(KERNEL_CONFIGURE_TARGET)
endif

.PHONY: kernel_configure kernel_configure_msg
.PHONY: $(PRE_KERNEL_CONFIGURE_TARGET) $(KERNEL_CONFIGURE_TARGET) $(POST_KERNEL_CONFIGURE_TARGET)

kernel_configure_msg:
	@$(MSG) "Configuring kernel for $(NAME)"
	@$(MSG)     - Kernel configure ARGS: $(KERNEL_CONFIGURE_ARGS)

pre_kernel_configure_target: kernel_configure_msg

kernel_configure_target:  $(PRE_KERNEL_CONFIGURE_TARGET)
	@$(MSG) "Updating kernel Makefile"
	@$(RUN) sed -r 's,^ARCH[^_]\s*.+,ARCH\t\t= $(KERNEL_ARCH),' -i.ARCH.orig Makefile
	@$(RUN) sed -r -e '/^ARCH/a\' -e 'CROSS_COMPILE\t= $(TC_PATH)$(TC_PREFIX)' -i.CROSS_COMPILE.orig Makefile
# Add "+" to EXTRAVERSION for kernels version >= 4.4
ifeq ($(call version_ge, ${TC_KERNEL}, 4.4),1)
	@$(RUN) sed -r -e 's,^EXTRAVERSION\s*.+,&+,' -e 's,=\+,= \+,' -i Makefile
endif
	@test -e $(WORK_DIR)/arch/$(KERNEL_ARCH) || $(RUN) ln -sf $(KERNEL_BASE_ARCH) arch/$(KERNEL_ARCH)
	@$(MSG) "Cleaning the kernel source"
	@$(RUN) $(MAKE) mrproper
	@$(MSG) "Applying $(KERNEL_CONFIG) configuration"
	@$(RUN) cp $(KERNEL_CONFIG) .config
	@$(MSG) "Set any new symbols to their default value"
# olddefconfig is not available < 3.8
ifeq ($(call version_lt, ${TC_KERNEL}, 3.8),1)
	@$(MSG) "oldconfig OLD style... $(TC_KERNEL) < 3.8"
	@$(RUN) yes "" | $(MAKE) oldconfig
else
	@$(RUN) $(MAKE) olddefconfig
endif
# Call to make kernelversion is not available for kernel <= 3.0
ifeq ($(call version_ge, ${TC_KERNEL}, 3),1)
	@$(MSG) "Get kernel version"
	@$(RUN) $(MAKE) kernelversion
endif

post_kernel_configure_target: $(KERNEL_CONFIGURE_TARGET)

ifeq ($(wildcard $(KERNEL_CONFIGURE_COOKIE)),)
kernel_configure: $(KERNEL_CONFIGURE_COOKIE)

$(KERNEL_CONFIGURE_COOKIE): $(POST_KERNEL_CONFIGURE_TARGET)
	$(create_target_dir)
	@touch -f $@
else
kernel_configure: ;
endif

