### Kernel module rules
#   Compile kernel modules as provided with the REQUIRE_KERNEL_MODULE variable.
# Targets are executed in the following order:
#  kernel_module_msg_target
#  pre_kernel_module_target    (override with PRE_KERNEL_MODULE_TARGET)
#  kernel_module_target        (override with KERNEL_MODULE_TARGET)
#  post_kernel_module_target   (override with POST_KERNEL_MODULE_TARGET)
# Variables:
#  ARCH                    Actual ARCH being built for
#  GENERIC_ARCHS           Names of generic ARCH groups (i.e. armv7, aarch64, x64, etc)
#  REQUIRE_KERNEL_MODULE   List of modules to be compiled
#  STAGING_INSTALL_PREFIX  Full installation path consisting of $(INSTALL_DIR)$(INSTALL_PREFIX)
#  WORK_DIR                Base directory used for compilation of specified ARCH
#  PKG_DIR                 The extracted package directory name
#  NAME                    Refers to $(KERNEL_NAME) being syno-$(KERNEL_ARCH)-$(KERNEL_VERS)
#  TC_KERNEL               Exact kernel version as provided by toolchain configuration $(WORK_DIR)/tc_vars.mk

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

pre_kernel_module_target: kernel_module_msg

.PHONY: kernel_module_prepare
kernel_module_prepare:
	@$(MSG) "DISTRIB_DIR = $(DISTRIB_DIR)"
	@$(MSG) "Prepare kernel source for module build"
	@$(RUN) $(MAKE) modules_prepare

.PHONY: kernel_module_target
kernel_module_target:  $(PRE_KERNEL_MODULE_TARGET) kernel_module_prepare
	@for module in $(REQUIRE_KERNEL_MODULE); \
	do \
	  $(MAKE) kernel_module_compile module=$$module ; \
	done

.PHONY: kernel_module_compile
kernel_module_compile:
	@$(MSG) Compiling kernel module module=$(module)
	@$(RUN) LDFLAGS="" $(MAKE) -C $(WORK_DIR)/$(PKG_DIR) INSTALL_MOD_PATH=$(STAGING_INSTALL_PREFIX) modules M=$(word 2,$(subst :, ,$(module))) $(firstword $(subst :, ,$(module)))=m $(lastword $(subst :, ,$(module))).ko
	@$(RUN) cat $(word 2,$(subst :, ,$(module)))/modules.order >> $(WORK_DIR)/$(PKG_DIR)/modules.order
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/lib/modules/$(subst syno-,,$(NAME))/$(TC_KERNEL)/$(word 2,$(subst :, ,$(module)))
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

