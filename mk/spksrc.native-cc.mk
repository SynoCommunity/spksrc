###############################################################################
# spksrc.native-cc.mk
#
# Default NATIVE make programs
#
###############################################################################

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

# Common makefiles
include ../../mk/spksrc.common.mk

#####

.NOTPARALLEL:

#####

include ../../mk/spksrc.native/env-default.mk

include ../../mk/spksrc.rules/depend.mk

include ../../mk/spksrc.rules/status.mk

# Strip legacy libtool archives (.la) for native builds by default: they are
# unneeded for host tools / static helper libs and actively break the multi-
# DESTDIR native dependency chain (a dependency's staged .la path gets double-
# prefixed by a downstream package's libtool). No native package currently
# ships a .la. Opt out per package with NATIVE_KEEP_LA = 1 (e.g. libltdl plugins).
INSTALL_REMOVE_LA ?= $(if $(NATIVE_KEEP_LA),,1)

# Standard build pipeline (download -> ... -> install)
include ../../mk/spksrc.build.mk

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
