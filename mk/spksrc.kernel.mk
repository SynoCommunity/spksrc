# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Common kernel variables
include ../../mk/spksrc.kernel-flags.mk

# Configure the included makefiles
NAME          = $(KERNEL_NAME)
URLS          = $(KERNEL_DIST_SITE)/$(KERNEL_DIST_NAME)
COOKIE_PREFIX = $(PKG_NAME)-

ifneq ($(strip $(REQUIRE_KERNEL_MODULE)),)
PKG_NAME      = linux-$(subst syno-,,$(NAME))
PKG_DIR       = $(PKG_NAME)
else
PKG_NAME      = linux
PKG_DIR       = $(PKG_NAME)
endif

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

# Always configure the kernel source tree
POST_EXTRACT_TARGET  = kernel_post_extract_target
COMPILE_TARGET       = nop
INSTALL_TARGET       = nop

# Only build kernel module on non-generic archs
ifneq ($(strip $(REQUIRE_KERNEL_MODULE)),)
ifneq ($(findstring $(ARCH),$(GENERIC_ARCHS)),$(ARCH))
PRE_COMPILE_TARGET   = kernel_module_prepare_target
COMPILE_TARGET       = kernel_module_compile_target
else
CONFIGURE_TARGET     = nop
endif
endif

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

kernel_configure: patch
include ../../mk/spksrc.kernel-configure.mk

compile: kernel_configure
include ../../mk/spksrc.compile.mk

install: compile
include ../../mk/spksrc.install.mk

plist: install
include ../../mk/spksrc.plist.mk

### For make digests
include ../../mk/spksrc.generate-digests.mk

.PHONY: kernel_post_extract_target

kernel_post_extract_target:
	mv $(WORK_DIR)/$(KERNEL_DIST) $(WORK_DIR)/$(PKG_DIR)

.PHONY: kernel_module_prepare_target

kernel_module_prepare_target:
	@$(MSG) "DISTRIB_DIR = $(DISTRIB_DIR)"
	@$(MSG) "Prepare kernel source for module build"
	$(RUN) $(MAKE) modules_prepare

.PHONY: kernel_module_compile_target

kernel_module_compile_target:
	@for module in $(REQUIRE_KERNEL_MODULE); \
	do \
	  $(MAKE) kernel_module_build module=$$module ; \
	done

kernel_module_build:
	@$(MSG) Building kernel module module=$(module)
	$(RUN) LDFLAGS="" $(MAKE) -C $(WORK_DIR)/$(PKG_DIR) INSTALL_MOD_PATH=$(STAGING_INSTALL_PREFIX) modules M=$(word 2,$(subst :, ,$(module))) $(firstword $(subst :, ,$(module)))=m $(lastword $(subst :, ,$(module))).ko
	$(RUN) cat $(word 2,$(subst :, ,$(module)))/modules.order >> $(WORK_DIR)/$(PKG_DIR)/modules.order
	$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/lib/modules/$(subst syno-,,$(NAME))/$(TC_KERNEL)/$(word 2,$(subst :, ,$(module)))
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/$(word 2,$(subst :, ,$(module)))/$(lastword $(subst :, ,$(module))).ko $(STAGING_INSTALL_PREFIX)/lib/modules/$(subst syno-,,$(NAME))/$(TC_KERNEL)/$(word 2,$(subst :, ,$(module)))


clean:
	rm -fr work work-*

all: install plist
