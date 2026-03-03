###############################################################################
# spksrc.kernel/module.mk
#
# Compile kernel modules for the target kernel and architecture.
#
# This file:
#  - prepares the kernel source for module compilation
#  - compiles modules listed in REQUIRE_KERNEL_MODULE
#  - installs compiled modules under
#      $(STAGING_INSTALL_PREFIX)/lib/modules/<arch>-<version>/
#
# Targets are executed in the following order:
#  kernel_module_msg_target
#  pre_kernel_module_target    (override with PRE_KERNEL_MODULE_TARGET)
#  kernel_module_target        (override with KERNEL_MODULE_TARGET)
#  post_kernel_module_target   (override with POST_KERNEL_MODULE_TARGET)
#
# Variables:
#   ARCH                     architecture being built
#   GENERIC_ARCHS            generic arch groups (e.g., armv7, aarch64, x64)
#   REQUIRE_KERNEL_MODULE    list of modules to compile
#   STAGING_INSTALL_PREFIX   full install path for compiled modules
#   WORK_DIR                 base directory for compilation
#   PKG_DIR                  extracted kernel source directory
#   NAME                     kernel name, defaults to $(KERNEL_NAME)
#   TC_KERNEL                exact kernel version from toolchain
#
# Notes:
#  - Module compilation is skipped for generic architectures
#  - Prepares kernel source with modules_prepare and olddefconfig/oldconfig
#  - Adjusts kernel Makefiles for warnings and tools where needed
###############################################################################

KERNEL_MODULE_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)kernel_module_done

ifeq ($(strip $(PRE_KERNEL_MODULE_TARGET)),)
PRE_KERNEL_MODULE_TARGET = pre_kernel_module_target
else
$(PRE_KERNEL_MODULE_TARGET): kernel_module_msg
endif
# Build kernel modules
# - only for non-generic archs
# - only when required (e.g. REQUIRE_KERNEL_MODULE not empty)
ifneq ($(findstring $(ARCH),$(GENERIC_ARCHS)),$(ARCH))
ifeq ($(strip $(REQUIRE_KERNEL_MODULE)),)
KERNEL_MODULE_TARGET = nop
else
ifeq ($(strip $(KERNEL_MODULE_TARGET)),)
KERNEL_MODULE_TARGET = kernel_module_target
else
$(KERNEL_MODULE_TARGET): $(PRE_KERNEL_MODULE_TARGET)
endif
endif
endif
ifeq ($(strip $(POST_KERNEL_MODULE_TARGET)),)
POST_KERNEL_MODULE_TARGET = post_kernel_module_target
else
$(POST_KERNEL_MODULE_TARGET): $(KERNEL_MODULE_TARGET)
endif

.PHONY: kernel_module kernel_module_msg
.PHONY: $(PRE_KERNEL_MODULE_TARGET) $(KERNEL_MODULE_TARGET) $(POST_KERNEL_MODULE_TARGET)

kernel_module_msg:
	@$(MSG) "Compiling kernel modules for $(NAME)"
	@$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s\n" "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$(ARCH)-$(TCVERSION)" "kernel-modules") | tee --append $(STATUS_LOG) ; \

pre_kernel_module_target: kernel_module_msg

.PHONY: kernel_module_prepare
kernel_module_prepare:
	@$(MSG) "DISTRIB_DIR = $(DISTRIB_DIR)"
	@$(MSG) "Prepare kernel source for module build"
	@for module in $(REQUIRE_KERNEL_MODULE); \
	do \
	  cd $(WORK_DIR)/$(PKG_DIR); scripts/config --module $${module%%:*} ; \
	done
# olddefconfig is not available on kernels < 3.8
ifeq ($(call version_lt, ${TC_KERNEL}, 3.8),1)
	@$(MSG) "make oldconfig OLD style... $(TC_KERNEL) < 3.8"
	@$(RUN) yes "" | $(MAKE) oldconfig
else
	@$(MSG) "make olddefconfig for kernel $(TC_KERNEL)"
	@$(RUN) $(MAKE) olddefconfig
endif
	@if [ -f $(WORK_DIR)/$(PKG_DIR)/tools/lib/subcmd/Makefile ]; then \
	  $(MSG) "- Disable gcc warnings as error in ./tools/lib/subcmd/Makefile (5.x kernels)." ; \
	  sed "s/-Wall //" -i.bak $(WORK_DIR)/$(PKG_DIR)/tools/lib/subcmd/Makefile ; \
	fi
	@if [ -f $(WORK_DIR)/$(PKG_DIR)/tools/objtool/Makefile ]; then \
	  $(MSG) "- Disable build of ./tools/objtool (5.x kernels)." ; \
	  echo "all:" > $(WORK_DIR)/$(PKG_DIR)/tools/objtool/Makefile ; \
	fi
	@$(RUN) $(MAKE) modules_prepare

.PHONY: kernel_module_target
kernel_module_target:  $(PRE_KERNEL_MODULE_TARGET) kernel_module_prepare
	@$(MSG) Compile kernel modules $(REQUIRE_KERNEL_MODULE)
	@for module in $(REQUIRE_KERNEL_MODULE); \
	do \
	  $(MAKE) kernel_module_compile module=$$module ; \
	done

.PHONY: kernel_module_compile
kernel_module_compile:
	@$(MSG) Compile kernel module module=$(module)
	@$(RUN) LDFLAGS="" $(MAKE) -C $(WORK_DIR)/$(PKG_DIR) M=$(word 2,$(subst :, ,$(module))) $(firstword $(subst :, ,$(module)))=m OBJECT_FILES_NON_STANDARD=y modules
	@$(RUN) cat $(word 2,$(subst :, ,$(module)))/modules.order >> $(WORK_DIR)/$(PKG_DIR)/modules.order
	install -d $(STAGING_INSTALL_PREFIX)/lib/modules/$(subst syno-,,$(NAME))/$(TC_KERNEL)/$(word 2,$(subst :, ,$(module)))
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/$(word 2,$(subst :, ,$(module)))/$(lastword $(subst :, ,$(module))).ko $(STAGING_INSTALL_PREFIX)/lib/modules/$(subst syno-,,$(NAME))/$(TC_KERNEL)/$(word 2,$(subst :, ,$(module)))

post_kernel_module_target: $(KERNEL_MODULE_TARGET)

ifeq ($(wildcard $(KERNEL_MODULE_COOKIE)),)
kernel_module: $(KERNEL_MODULE_COOKIE)

$(KERNEL_MODULE_COOKIE): $(POST_KERNEL_MODULE_TARGET)
	$(create_target_dir)
	@touch -f $@
else
kernel_module: ;
endif
