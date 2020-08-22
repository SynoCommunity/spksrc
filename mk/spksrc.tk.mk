
# Constants
SHELL := $(SHELL) -e
default: all

WORK_DIR := $(shell pwd)/work
include ../../mk/spksrc.directories.mk


# Configure the included makefiles
URLS          = $(TK_DIST_SITE)/$(TK_DIST_NAME)
NAME          = $(TK_NAME)
COOKIE_PREFIX = $(TK_NAME)-
ifneq ($(TK_DIST_FILE),)
LOCAL_FILE    = $(TK_DIST_FILE)
# download.mk uses PKG_DIST_FILE
PKG_DIST_FILE = $(TK_DIST_FILE)
else
LOCAL_FILE    = $(TK_DIST_NAME)
endif
DISTRIB_DIR   = $(TOOLKITS_DIR)/$(TK_VERS)
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(TK_EXT)
EXTRACT_CMD   = $(EXTRACT_CMD.$(DIST_EXT)) --skip-old-files --strip-components=$(TK_STRIP) usr/$(TK_PREFIX)/$(TK_BASE_DIR)/$(TK_SYSROOT)

#####

RUN = cd $(WORK_DIR)/$(TK_BASE_DIR) && env $(ENV)
MSG = echo "===>   "

include ../../mk/spksrc.download.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum
include ../../mk/spksrc.extract.mk

patch: extract
include ../../mk/spksrc.patch.mk

fix: patch
include ../../mk/spksrc.tk-fix.mk

all: fix

### Clean rules
clean:
	rm -fr $(WORK_DIR)

### For make digests
include ../../mk/spksrc.generate-digests.mk
