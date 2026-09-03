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

# Standard build pipeline (download -> ... -> install)
include ../../mk/spksrc.build.mk

###

.PHONY: cat_PLIST
cat_PLIST:
	@true

###

# Define _all as a real target that does the work. 'archive' runs after install
# and is a no-op unless the package declares ARCHIVE_NAME (see
# spksrc.build/archive.mk).
.PHONY: _all
_all: install archive

# all wraps _all with logging
.PHONY: all
.DEFAULT_GOAL := all

all:
	@mkdir -p $(WORK_DIR)
	$(call RUNLOG,_all)

####

### Include common rules
include ../../mk/spksrc.rules.mk

# nativeclean -- like spkclean: re-run every step next make, keeping the work dir.
# Only the master package's cookies, listed (not a glob): a shared-work-dir dep
# whose name extends this one's (llvm -> llvm-140) must keep its own.
.PHONY: nativeclean
nativeclean:
	rm -f $(DOWNLOAD_COOKIE) $(CHECKSUM_COOKIE) $(EXTRACT_COOKIE) $(PATCH_COOKIE) \
	      $(DEPEND_COOKIE) $(CONFIGURE_COOKIE) $(COMPILE_COOKIE) $(INSTALL_COOKIE) \
	      $(STATUS_COOKIE) $(ARCHIVE_COOKIE)

### Optional archive packaging (build-archive); no-op unless ARCHIVE is set
include ../../mk/spksrc.build/archive.mk

###
