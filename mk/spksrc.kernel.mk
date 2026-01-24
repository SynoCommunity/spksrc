
# Constants
default: all

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

# Prior to interacting with the kernel files
# move the kernel source tree to its final destination
POST_EXTRACT_TARGET      = kernel_post_extract_target

# By default do not install kernel headers
INSTALL_TARGET           = nop

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
include ../../mk/spksrc.cross-kernel-configure.mk

kernel_module: kernel_configure
include ../../mk/spksrc.cross-kernel-module.mk

install: kernel_module
include ../../mk/spksrc.cross-kernel-headers.mk

install: kernel_headers
include ../../mk/spksrc.install.mk

plist: install
include ../../mk/spksrc.plist.mk

.PHONY: kernel_post_extract_target
kernel_post_extract_target:
	mv $(WORK_DIR)/$(KERNEL_DIST) $(WORK_DIR)/$(PKG_DIR)

all: install plist

# Common rules makefiles
include ../../mk/spksrc.common-rules.mk
