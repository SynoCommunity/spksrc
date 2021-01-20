# Constants
SHELL := $(SHELL) -e
default: all

WORK_DIR := $(shell pwd)/work
include ../../mk/spksrc.directories.mk

# Configure the included makefiles
URLS               = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME               = $(PKG_NAME)
COOKIE_PREFIX      = $(PKG_NAME)-
ifneq ($(PKG_DIST_FILE),)
LOCAL_FILE         = $(PKG_DIST_FILE)
else
LOCAL_FILE         = $(PKG_DIST_NAME)
endif
DIST_FILE          = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT           = $(PKG_EXT)
DISTRIB_DIR        = $(KERNEL_DIR)/$(PKG_BRANCH)
PRE_COMPILE_TARGET = kernel_module_prepare_target
COMPILE_TARGET     = nop
EXTRACT_TARGET     = kernel_extract_target
CONFIGURE_TARGET   = kernel_configure_target
COPY_TARGET        = nop

TC ?= syno-$(ARCH)-$(TCVERSION)

include ../../mk/spksrc.cross-env.mk
#####

KERNEL_ENV ?=
KERNEL_ENV += PATH=$$PATH

RUN = cd $(KERNEL_SOURCE_DIR) && env -i $(KERNEL_ENV)
MSG = echo "===>   "

.PHONY: kernel_module_prepare_target kernel_module_compile_target kernel_extract_target kernel_configure_target

include ../../mk/spksrc.download.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum
include ../../mk/spksrc.extract.mk

patch: extract
include ../../mk/spksrc.patch.mk

configure: patch
include ../../mk/spksrc.configure.mk

compile: configure
include ../../mk/spksrc.compile.mk

all: compile

### Clean rules
clean:
	rm -fr $(WORK_DIR)

### For make digests
include ../../mk/spksrc.generate-digests.mk

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
	cp $(KERNEL_SOURCE_DIR)/$(SYNO_CONFIG) $(KERNEL_SOURCE_DIR)/.config
	# Update the Makefile
	sed -i -r 's,^ARCH\s*.+,ARCH\t= $(BASE_ARCH),' $(KERNEL_SOURCE_DIR)/Makefile
	sed -i -r 's,^CROSS_COMPILE\s*.+,CROSS_COMPILE\t= $(TC_PATH)$(TC_PREFIX),' $(KERNEL_SOURCE_DIR)/Makefile
ifeq ($(shell expr "$(word 1,$(subst ., ,$(TC_KERNEL)))" \>= 4),1)
	sed -i -r -e 's,^EXTRAVERSION\s*.+,&+,' -e 's,=\+,= \+,' $(KERNEL_SOURCE_DIR)/Makefile
endif
	test -e $(WORK_DIR)/$(KERNEL_SOURCE_DIR)/arch/$(ARCH) || ln -sf $(BASE_ARCH) $(KERNEL_SOURCE_DIR)/arch/$(ARCH)
