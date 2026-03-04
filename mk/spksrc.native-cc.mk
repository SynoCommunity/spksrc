#
# Default NATIVE make programs
#

# Package dependent
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = $(PKG_NAME)
COOKIE_PREFIX = $(PKG_NAME)-
ifneq ($(PKG_DIST_FILE),)
LOCAL_FILE    = $(PKG_DIST_FILE)
else
LOCAL_FILE    = $(PKG_DIST_NAME)
endif
DIST_FILE     = $(DISTRIB_DIR)/$(LOCAL_FILE)
DIST_EXT      = $(PKG_EXT)
ARCH_SUFFIX  := -native

# Setup common directories
include ../../mk/spksrc.common/directories.mk

# Common makefiles
include ../../mk/spksrc.common.mk

#####

.NOTPARALLEL:

#####

include ../../mk/spksrc.native/env.mk

include ../../mk/spksrc.build/download.mk

include ../../mk/spksrc.rules/depend.mk

include ../../mk/spksrc.rules/status.mk

checksum: download
include ../../mk/spksrc.build/checksum.mk

extract: checksum depend status
include ../../mk/spksrc.build/extract.mk

patch: extract
include ../../mk/spksrc.build/patch.mk

configure: patch
include ../../mk/spksrc.build/configure.mk

compile: configure
include ../../mk/spksrc.build/compile.mk

install: compile
include ../../mk/spksrc.build/install.mk

###

.PHONY: cat_PLIST
cat_PLIST:
	@true

###

# Define _all as a real target that does the work
.PHONY: _all
_all: install

# all wraps _all with logging
.PHONY: all
.DEFAULT_GOAL := all

all:
	@mkdir -p $(WORK_DIR)
	$(call LOG_WRAPPED,_all)

####

### Include common rules
include ../../mk/spksrc.rules.mk

###
