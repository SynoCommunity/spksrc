
# Constants
SHELL := $(SHELL) -e
default: all

WORK_DIR := $(CURDIR)/work
include ../../mk/spksrc.directories.mk

include ../../mk/spksrc.common.mk

# Configure the included makefiles
URLS          = $(TK_DIST_SITE)/$(TK_DIST_NAME)
NAME          = $(TK_NAME)
COOKIE_PREFIX = 
ifneq ($(TK_DIST_FILE),)
LOCAL_FILE    = $(TK_DIST_FILE)
# download.mk uses PKG_DIST_FILE
PKG_DIST_FILE = $(TK_DIST_FILE)
else
LOCAL_FILE    = $(TK_DIST_NAME)
endif
DISTRIB_DIR   = $(TOOLKIT_DIR)/$(TK_VERS)
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(TK_EXT)
EXTRACT_CMD   = $(EXTRACT_CMD.$(DIST_EXT)) --skip-old-files --strip-components=$(TK_STRIP) usr/$(TK_PREFIX)/$(TK_BASE_DIR)/$(TK_SYSROOT_PATH)

#####

RUN = cd $(WORK_DIR)/$(TK_TARGET) && env $(ENV)

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

### For make digests
include ../../mk/spksrc.generate-digests.mk
