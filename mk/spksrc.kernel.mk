# Constants
SHELL := $(SHELL) -e
default: all

WORK_DIR := $(shell pwd)/work
include ../../mk/spksrc.directories.mk
include ../../mk/spksrc.kernel-flags.mk

# Configure the included makefiles
URLS          = $(KERNEL_DIST_SITE)/$(KERNEL_DIST_NAME)
NAME          = $(KERNEL_NAME)
COOKIE_PREFIX = 
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
#EXTRACT_CMD   = $(EXTRACT_CMD.$(DIST_EXT)) --skip-old-files --strip-components=$(KERNEL_STRIP) usr/$(KERNEL_PREFIX)/$(KERNEL_BASE_DIR)/$(KERNEL_SYSROOT)
EXTRACT_CMD   = $(EXTRACT_CMD.$(DIST_EXT)) --skip-old-files --strip-components=$(KERNEL_STRIP)

#####

RUN = cd $(WORK_DIR) && env $(ENV)
MSG = echo "===>   "

include ../../mk/spksrc.download.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum
include ../../mk/spksrc.extract.mk

patch: extract
include ../../mk/spksrc.patch.mk

compile: patch
include ../../mk/spksrc.kernel-modules.mk

all: compile

### Clean rules
clean:
	rm -fr $(WORK_DIR)

### For make digests
include ../../mk/spksrc.generate-digests.mk
