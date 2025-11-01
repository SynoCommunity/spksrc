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
include ../../mk/spksrc.directories.mk

# Common makefiles
include ../../mk/spksrc.common.mk

#####

.NOTPARALLEL:

#####

include ../../mk/spksrc.native-env.mk

include ../../mk/spksrc.download.mk

include ../../mk/spksrc.depend.mk

include ../../mk/spksrc.status.mk

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
	@bash -o pipefail -c ' \
	   if [ -z "$$LOGGING_ENABLED" ]; then \
	      export LOGGING_ENABLED=1 ; \
	      { \
	        $(MAKE) -f $(firstword $(MAKEFILE_LIST)) _all ; \
	      } > >(tee --append $(NATIVE_LOG)) 2>&1 ; \
	   else \
	      $(MAKE) -f $(firstword $(MAKEFILE_LIST)) _all ; \
	   fi \
	' || { \
	   $(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s - FAILED\n" "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "native" "$(NAME)") | tee --append $(STATUS_LOG) ; \
	   exit 1 ; \
	}

####

### Include common rules
include ../../mk/spksrc.common-rules.mk

###
