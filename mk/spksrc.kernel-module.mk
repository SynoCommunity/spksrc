### Kernel module rules
#   Compile kernel modules as provided thru the REQUIRE_KERNEL_MODULE variable.
# Targets are executed in the following order:
#  kernel_module_msg_target
#  pre_kernel_module_target    (override with PRE_KERNEL_MODULE_TARGET)
#  kernel_module_target        (override with KERNEL_MODULE_TARGET)
#  post_kernel_module_target   (override with POST_KERNEL_MODULE_TARGET)
# Variables:
#  REQUIRE_KERNEL_MODULE   TBD
#  STAGING_INSTALL_PREFIX  TBD
#  WORK_DIR                TBD
#  PKG_DIR                 TBD
#  NAME                    TBD
#  TC_KERNEL               TBD

KERNEL_MODULE_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)kernel_module_done

ifeq ($(strip $(PRE_KERNEL_MODULE_TARGET)),)
PRE_KERNEL_MODULE_TARGET = pre_kernel_module_target
else
$(PRE_KERNEL_MODULE_TARGET): kernel_module_msg
endif
ifeq ($(strip $(KERNEL_MODULE_TARGET)),)
KERNEL_MODULE_TARGET = kernel_module_target
else
$(KERNEL_MODULE_TARGET): $(PRE_KERNEL_MODULE_TARGET)
endif
ifeq ($(strip $(POST_KERNEL_MODULE_TARGET)),)
POST_KERNEL_MODULE_TARGET = post_kernel_module_target
else
$(POST_KERNEL_MODULE_TARGET): $(KERNEL_MODULE_TARGET)
endif

.PHONY: kernel_module kernel_module_msg
.PHONY: $(PRE_KERNEL_MODULE_TARGET) $(KERNEL_MODULE_TARGET) $(POST_KERNEL_MODULE_TARGET)

kernel_module_msg:
	@$(MSG) "Compiling for $(NAME)"

pre_kernel_module_target: kernel_module_msg

.PHONY: kernel_module_prepare
kernel_module_prepare:
	@$(MSG) "DISTRIB_DIR = $(DISTRIB_DIR)"
	@$(MSG) "Prepare kernel source for module build"
	$(RUN) $(MAKE) modules_prepare

.PHONY: kernel_module_target
kernel_module_target:  $(PRE_KERNEL_MODULE_TARGET) kernel_module_prepare
	@for module in $(REQUIRE_KERNEL_MODULE); \
	do \
	  $(MAKE) kernel_module_compile module=$$module ; \
	done

.PHONY: kernel_module_compile
kernel_module_compile:
	@$(MSG) Compiling kernel module module=$(module)
	$(RUN) LDFLAGS="" $(MAKE) -C $(WORK_DIR)/$(PKG_DIR) INSTALL_MOD_PATH=$(STAGING_INSTALL_PREFIX) modules M=$(word 2,$(subst :, ,$(module))) $(firstword $(subst :, ,$(module)))=m $(lastword $(subst :, ,$(module))).ko
	$(RUN) cat $(word 2,$(subst :, ,$(module)))/modules.order >> $(WORK_DIR)/$(PKG_DIR)/modules.order
	$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/lib/modules/$(subst syno-,,$(NAME))/$(TC_KERNEL)/$(word 2,$(subst :, ,$(module)))
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

