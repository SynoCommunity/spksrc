# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Common kernel variables
include ../../mk/spksrc.kernel-flags.mk

# Configure the included makefiles
NAME          = $(KERNEL_NAME)
COOKIE_PREFIX = linux-
URLS          = $(KERNEL_DIST_SITE)/$(KERNEL_DIST_NAME)
PKG_NAME      = linux
PKG_DIR       = $(PKG_NAME)
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
EXTRACT_CMD   = $(EXTRACT_CMD.$(KERNEL_EXT)) --skip-old-files --strip-components=$(KERNEL_STRIP) $(KERNEL_PREFIX)

#####

# Configure the included makefiles
PRE_CONFIGURE_TARGET = kernel_pre_configure_target
CONFIGURE_TARGET     = kernel_configure_target
PRE_COMPILE_TARGET   = kernel_module_prepare_target
ifeq ($(strip $(REQUIRE_KERNEL_MODULE)),)
COMPILE_TARGET       = nop
else
COMPILE_TARGET       = kernel_module_compile_target
endif
# spksrc.install.mk called for PRE_INSTALL_PLIST
# in order to generate a work*/linux.plist.auto
# later used by spksr.plist.mk to generate the
# diff based on .ko kernel objects
INSTALL_TARGET       = nop

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

install: compile
include ../../mk/spksrc.install.mk

plist: install
include ../../mk/spksrc.plist.mk

clean:
	rm -fr work work-*

all: install plist

### For make digests
include ../../mk/spksrc.generate-digests.mk

.PHONY: kernel_pre_configure_target

kernel_pre_configure_target:
	mv $(WORK_DIR)/$(KERNEL_DIST) $(WORK_DIR)/linux

.PHONY: kernel_configure_target

kernel_configure_target: 
	@$(MSG) "Updating kernel Makefile"
	$(RUN) sed -i -r 's,^CROSS_COMPILE\s*.+,CROSS_COMPILE\t= $(TC_PATH)$(TC_PREFIX),' Makefile
	$(RUN) sed -i -r 's,^ARCH\s*.+,ARCH\t= $(KERNEL_ARCH),' Makefile
# Add "+" to EXTRAVERSION for kernels version >= 4.4
ifeq ($(call version_ge, ${TC_KERNEL}, 4.4),1)
	$(RUN) sed -i -r -e 's,^EXTRAVERSION\s*.+,&+,' -e 's,=\+,= \+,' Makefile
endif
	test -e $(WORK_DIR)/arch/$(KERNEL_ARCH) || $(RUN) ln -sf $(KERNEL_BASE_ARCH) arch/$(KERNEL_ARCH)
	@$(MSG) "Cleaning the kernel source"
	$(RUN) $(MAKE) mrproper
	@$(MSG) "Applying $(KERNEL_CONFIG) configuration"
	$(RUN) cp $(KERNEL_CONFIG) .config
	@$(MSG) "Set any new symbols to their default value"
# olddefconfig is not available < 3.8
ifeq ($(call version_lt, ${TC_KERNEL}, 3.8),1)
	@$(MSG) "oldconfig OLD style... $(TC_KERNEL) < 3.8"
	$(RUN) yes "" | $(MAKE) oldconfig
else
	$(RUN) $(MAKE) olddefconfig
endif

.PHONY: kernel_module_prepare_target

kernel_module_prepare_target:
	@$(MSG) "DISTRIB_DIR = $(DISTRIB_DIR)"
	@$(MSG) "Prepare kernel source for module build"
	$(RUN) $(MAKE) modules_prepare
# Call to make kernelversion is not available for kernel <= 3.0
ifeq ($(call version_ge, ${TC_KERNEL}, 3),1)
	@$(MSG) "Get kernel version"
	$(RUN) $(MAKE) kernelversion
endif

.PHONY: kernel_module_compile_target

kernel_module_compile_target:
	@for module in $(REQUIRE_KERNEL_MODULE); \
	do \
	  $(MAKE) kernel_module_build module=$$module ; \
	done

kernel_module_build:
	@$(MSG) Building kernel module module=$(module)
	$(RUN) LDFLAGS="" $(MAKE) -C $(WORK_DIR)/linux INSTALL_MOD_PATH=$(STAGING_INSTALL_PREFIX) modules M=$(word 2,$(subst :, ,$(module))) $(firstword $(subst :, ,$(module)))=m $(lastword $(subst :, ,$(module))).ko
	$(RUN) cat $(word 2,$(subst :, ,$(module)))/modules.order >> $(WORK_DIR)/linux/modules.order
	$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/lib/modules/$(TC_KERNEL)/kernel/$(word 2,$(subst :, ,$(module)))
	install -m 644 $(WORK_DIR)/linux/$(word 2,$(subst :, ,$(module)))/$(lastword $(subst :, ,$(module))).ko $(STAGING_INSTALL_PREFIX)/lib/modules/$(TC_KERNEL)/kernel/$(word 2,$(subst :, ,$(module)))
