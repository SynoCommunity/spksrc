# Configure the included makefiles
PRE_COMPILE_TARGET = kernel_module_prepare_target
COMPILE_TARGET     = nop
EXTRACT_TARGET     = kernel_extract_target
CONFIGURE_TARGET   = kernel_configure_target
COPY_TARGET        = nop

#####

TC ?= syno-$(KERNEL_ARCH)-$(KERNEL_VERS)

include ../../mk/spksrc.cross-env.mk

#####

KERNEL_ENV ?=
KERNEL_ENV += PATH=$$PATH

RUN = cd $(WORK_DIR) && env -i $(KERNEL_ENV)
MSG = echo "===>   "

.PHONY: kernel_module_prepare_target kernel_module_compile_target kernel_extract_target kernel_configure_target

include ../../mk/spksrc.configure.mk

compile: configure
include ../../mk/spksrc.compile.mk

all: compile

kernel_module_prepare_target:
	@$(MSG) "Prepare kernel source for module build"
	$(RUN) $(MAKE) modules_prepare
ifeq ($(shell expr "$(word 1,$(subst ., ,$(TC_KERNEL)))" \>= 3),1)
	@$(MSG) "Get kernel version"
	$(RUN) $(MAKE) kernelversion
endif

kernel_module_compile_target:
	$(RUN) $(MAKE) modules

kernel_extract_target:
	mkdir -p $(KERNEL_SOURCE_DIR)
	rm -rf $(KERNEL_SOURCE_DIR)
	tar -xpf $(DIST_FILE) -C $(EXTRACT_PATH) $(PKG_EXTRACT)
	mv $(EXTRACT_PATH)/$(PKG_EXTRACT) $(KERNEL_SOURCE_DIR)

kernel_configure_target: 
	@$(MSG) "Configuring depended kernel source"
	$(RUN) $(MAKE) mrproper
	cp $(WORK_DIR)/$(KERNEL_CONFIG) $(WORK_DIR)/.config
	# Update the Makefile
	sed -i -r 's,^ARCH\s*.+,ARCH\t= $(KERNEL_ARCH),' $(WORK_DIR)/Makefile
	sed -i -r 's,^CROSS_COMPILE\s*.+,CROSS_COMPILE\t= $(TC_PATH)$(TC_PREFIX),' $(WORK_DIR)/Makefile
ifeq ($(shell expr "$(word 1,$(subst ., ,$(TC_KERNEL)))" \>= 4),1)
	sed -i -r -e 's,^EXTRAVERSION\s*.+,&+,' -e 's,=\+,= \+,' $(WORK_DIR)/Makefile
endif
	test -e $(WORK_DIR)/arch/$(KERNEL_ARCH) || ln -sf $(KERNEL_BASE_ARCH) $(WORK_DIR)/arch/$(KERNEL_ARCH)
