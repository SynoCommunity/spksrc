###############################################################################
# spksrc.kernel/configure.mk
#
# Defines kernel configuration rules.
#
# This file:
#  - prepares kernel sources for module compilation
#  - aligns ARCH and CROSS_COMPILE with toolchain settings
#  - applies the selected kernel configuration
#  - normalizes configuration symbols (oldconfig / olddefconfig)
#  - exposes override hooks for custom configure steps
#
# Targets (execution order):
#
#   kernel_configure_msg
#   pre_kernel_configure_target    (override: PRE_KERNEL_CONFIGURE_TARGET)
#   kernel_configure_target        (override: KERNEL_CONFIGURE_TARGET)
#   post_kernel_configure_target   (override: POST_KERNEL_CONFIGURE_TARGET)
#
# Main target:
#
#   kernel_configure
#     └── guarded by KERNEL_CONFIGURE_COOKIE
#
# Variables:
#
#   KERNEL_CONFIGURE_ARGS   Reserved (currently unused)
#   KERNEL_ARCH             Target kernel ARCH value
#   KERNEL_BASE_ARCH        Default arch directory in source tree
#   KERNEL_CONFIG           Kernel .config used for module builds
#   NAME                    syno-$(KERNEL_ARCH)-$(KERNEL_VERS)
#
# Toolchain variables (from tc_vars.mk):
#
#   TC_KERNEL               Exact kernel version from toolchain
#   TC_PATH                 Toolchain binary path
#   TC_PREFIX               Toolchain triplet prefix
#
# Behavior notes:
#
#  - Updates kernel Makefile ARCH and CROSS_COMPILE
#  - Adds "+" to EXTRAVERSION for kernels >= 4.4
#  - Uses:
#       oldconfig     for kernels < 3.8
#       olddefconfig  for kernels >= 3.8
#  - Calls "make kernelversion" for kernels >= 3.0
#  - Ensures arch/$(KERNEL_ARCH) symlink exists
#
###############################################################################

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
	@$(MSG) "make olddefconfig for kernel $(TC_KERNEL)"
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

