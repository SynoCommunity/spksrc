
# Constants
SHELL := $(SHELL) -e
default: all

WORK_DIR := $(shell pwd)/work
include ../../mk/spksrc.directories.mk


# Configure the included makefiles
URLS          = $(TOOLKIT_DIST_SITE)/$(TOOLKIT_DIST_NAME)
NAME          = $(TOOLKIT_NAME)
COOKIE_PREFIX = 
ifneq ($(TOOLKIT_DIST_FILE),)
LOCAL_FILE    = $(TOOLKIT_DIST_FILE)
# download.mk uses PKG_DIST_FILE
PKG_DIST_FILE = $(TOOLKIT_DIST_FILE)
else
LOCAL_FILE    = $(TOOLKIT_DIST_NAME)
endif
DISTRIB_DIR   = $(TOOLKIT_DIR)/$(TOOLKIT_VERS)
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(TOOLKIT_EXT)
EXTRACT_CMD   = $(EXTRACT_CMD.$(DIST_EXT)) --skip-old-files --strip-components=$(TOOLKIT_STRIP) usr/$(TOOLKIT_PREFIX)/$(TOOLKIT_BASE_DIR)/$(TOOLKIT_SYSROOT)

#####

RUN = cd $(WORK_DIR)/$(TOOLKIT_TARGET) && env $(ENV)

include ../../mk/spksrc.download.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum
include ../../mk/spksrc.extract.mk

patch: extract
include ../../mk/spksrc.patch.mk

flags: patch
include ../../mk/spksrc.toolkit-flags.mk

toolkit_fix: flags
include ../../mk/spksrc.toolkit-fix.mk

all: toolkit_fix

### Clean rules
clean:
	rm -fr $(WORK_DIR)

### For make digests
include ../../mk/spksrc.generate-digests.mk
