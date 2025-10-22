#
# Default make programs
#

# Configure the included makefiles
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

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
ifneq ($(ARCH),noarch)
TC = syno$(ARCH_SUFFIX)
endif
endif

# Common directories (must be set after ARCH_SUFFIX)
include ../../mk/spksrc.directories.mk

# Common makefiles
include ../../mk/spksrc.common.mk

#####

status:
ifneq ($(wildcard $(WORK_DIR)/.$(NAME)-depend_done)),)
	@$(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s\n" "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$(ARCH)-$(TCVERSION)" "$(NAME)") | tee --append $(STATUS_LOG)
endif

#####

include ../../mk/spksrc.pre-check.mk

include ../../mk/spksrc.cross-env.mk

include ../../mk/spksrc.download.mk

include ../../mk/spksrc.depend.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum depend status
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

###

# Define _all as a real target that does the work
.PHONY: _all
_all: install plist

# all wraps _all with logging
.PHONY: all
.DEFAULT_GOAL := all

all:
	@mkdir -p $(WORK_DIR)
	@bash -o pipefail -c ' \
	   if [ -z "$$LOGGING_ENABLED" ]; then \
	      export LOGGING_ENABLED=1 ; \
	      { \
	        $(MAKE) -f $(firstword $(MAKEFILE_LIST)) _all ; \
	      } > >(tee --append $(DEFAULT_LOG)) 2>&1 ; \
	   else \
	      $(MAKE) -f $(firstword $(MAKEFILE_LIST)) _all ; \
	   fi \
	' || { \
	   $(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s - FAILED\n" "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$(ARCH)-$(TCVERSION)" "$(NAME)") | tee --append $(STATUS_LOG) ; \
	   exit 1 ; \
	}

####

### For arch-* and all-<supported|latest>
include ../../mk/spksrc.supported.mk

####
