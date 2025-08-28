### Configure rules
#   Install kernel headers in $(INSTALL_PREFIX)/include/linux/<arch>-<version>/
# Targets are executed in the following order:
#  kernel_headers_msg_target
#  pre_kernel_headers_target    (override with PRE_KERNEL_HEADERS_TARGET)
#  kernel_headers_target        (override with KERNEL_HEADERS_TARGET)
#  post_kernel_headers_target   (override with POST_KERNEL_HEADERS_TARGET)
# Variables:
#  KERNEL_HEADERS          When set to 1 will install kernel headers
#  KERNEL_HEADERS_ARGS     Currently unused, may be used at a later time
#  KERNEL_ARCH             Kernel arch as define in kernel/syno-<arch>-<version>/Makefile
#  NAME                    Refers to $(KERNEL_NAME) being syno-$(KERNEL_ARCH)-$(KERNEL_VERS)

KERNEL_HEADERS_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)kernel_headers_done

ifeq ($(strip $(PRE_KERNEL_HEADERS_TARGET)),)
PRE_KERNEL_HEADERS_TARGET = pre_kernel_headers_target
else
$(PRE_KERNEL_HEADERS_TARGET): kernel_headers_msg
endif
ifneq ($(strip $(KERNEL_HEADERS)),1)
KERNEL_HEADERS_TARGET = nop
else
ifeq ($(strip $(KERNEL_HEADERS_TARGET)),)
KERNEL_HEADERS_TARGET = kernel_headers_target
else
$(KERNEL_HEADERS_TARGET): $(PRE_KERNEL_HEADERS_TARGET)
endif
endif
ifeq ($(strip $(POST_KERNEL_HEADERS_TARGET)),)
POST_KERNEL_HEADERS_TARGET = post_kernel_headers_target
else
$(POST_KERNEL_HEADERS_TARGET): $(KERNEL_HEADERS_TARGET)
endif

.PHONY: kernel_headers kernel_headers_msg
.PHONY: $(PRE_KERNEL_HEADERS_TARGET) $(KERNEL_HEADERS_TARGET) $(POST_KERNEL_HEADERS_TARGET)

kernel_headers_msg:
	@$(MSG) "Installing kernel headers for $(NAME)"
	@$(MSG)     - Kernel headers ARGS: $(KERNEL_HEADERS_ARGS)

pre_kernel_headers_target: kernel_headers_msg

kernel_headers_target:  $(PRE_KERNEL_HEADERS_TARGET)
	@$(RUN) make ARCH=$(KERNEL_ARCH) INSTALL_HDR_PATH=$(STAGING_INSTALL_PREFIX)/include/linux headers_install
	@$(MSG) "Adjusting kernel headers path"
	@$(RUN) mv $(STAGING_INSTALL_PREFIX)/include/linux/include $(STAGING_INSTALL_PREFIX)/include/linux/$(subst syno-,,$(NAME))
	@$(RUN) find $(STAGING_INSTALL_PREFIX)/include/linux/$(subst syno-,,$(NAME))/. -type f \
	          -exec sed -i 's?$(STAGING_INSTALL_PREFIX)/include/linux/include?$(INSTALL_PREFIX)/include/linux/$(subst syno-,,$(NAME))?g' {} \;

post_kernel_headers_target: $(KERNEL_HEADERS_TARGET)

ifeq ($(wildcard $(KERNEL_HEADERS_COOKIE)),)
kernel_headers: $(KERNEL_HEADERS_COOKIE)

$(KERNEL_HEADERS_COOKIE): $(POST_KERNEL_HEADERS_TARGET)
	$(create_target_dir)
	@touch -f $@
else
kernel_headers: ;
endif

