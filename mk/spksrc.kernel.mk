# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Common kernel variables
include ../../mk/spksrc.kernel-flags.mk

# Configure the included makefiles
URLS          = $(KERNEL_DIST_SITE)/$(KERNEL_DIST_NAME)
PKG_DIR       = linux
ifneq ($(KERNEL_DIST_FILE),)
LOCAL_FILE    = $(KERNEL_DIST_FILE)
# download.mk uses PKG_DIST_FILE
PKG_DIST_FILE = $(KERNEL_DIST_FILE)
else
LOCAL_FILE    = $(KERNEL_DIST_NAME)
endif
DISTRIB_DIR   = $(KERNEL_DIR)/$(KERNEL_VERS)
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(KERNEL_EXT)
EXTRACT_CMD   = $(EXTRACT_CMD.$(KERNEL_EXT)) --skip-old-files --strip-components=$(KERNEL_STRIP)

#####

# Configure the included makefiles
PRE_COMPILE_TARGET  = kernel_module_prepare_target
COMPILE_TARGET      = nop
POST_EXTRACT_TARGET = kernel_post_extract_target
CONFIGURE_TARGET    = kernel_configure_target
COPY_TARGET         = nop

#####

TC ?= syno-$(KERNEL_ARCH)-$(KERNEL_VERS)

#####

include ../../mk/spksrc.cross-env.mk

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

clean:
	rm -fr work work-*

all: compile

### For make digests
include ../../mk/spksrc.generate-digests.mk

.PHONY: kernel_module_prepare_target

kernel_module_prepare_target:
	@$(MSG) "DISTRIB_DIR = $(DISTRIB_DIR)"
	@$(MSG) "Prepare kernel source for module build"
	$(RUN) $(MAKE) modules_prepare
ifeq ($(shell expr "$(word 1,$(subst ., ,$(TC_KERNEL)))" \>= 3),1)
	@$(MSG) "Get kernel version"
	$(RUN) $(MAKE) kernelversion
endif

.PHONY: kernel_module_compile_target

kernel_module_compile_target:
	$(RUN) $(MAKE) modules

.PHONY: kernel_post_extract_target

kernel_post_extract_target:
	mv $(WORK_DIR)/$(KERNEL_DIST) $(WORK_DIR)/linux

.PHONY: kernel_configure_target

kernel_configure_target: 
	@$(MSG) "Updating kernel Makefile"
	$(RUN) sed -i -r 's,^CROSS_COMPILE\s*.+,CROSS_COMPILE\t= $(TC_PATH)$(TC_PREFIX),' Makefile
	@$(MSG) "Cleaning the kernel source"
	$(RUN) $(MAKE) mrproper
	@$(MSG) "Applying $(KERNEL_CONFIG) configuration"
	$(RUN) cp $(KERNEL_CONFIG) .config
	$(RUN) sed -i -r 's,^ARCH\s*.+,ARCH\t= $(KERNEL_ARCH),' Makefile
ifeq ($(shell expr "$(word 1,$(subst ., ,$(TC_KERNEL)))" \>= 4),1)
	$(RUN) sed -i -r -e 's,^EXTRAVERSION\s*.+,&+,' -e 's,=\+,= \+,' Makefile
endif
	test -e $(WORK_DIR)/arch/$(KERNEL_ARCH) || $(RUN) ln -sf $(KERNEL_BASE_ARCH) arch/$(KERNEL_ARCH)
