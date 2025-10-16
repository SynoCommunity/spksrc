# Common makefiles
include ../../mk/spksrc.common.mk

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

# Setup common directories
include ../../mk/spksrc.directories.mk

#####

# native specific environment
include ../../mk/spksrc.native-env.mk

include ../../mk/spksrc.download.mk

include ../../mk/spksrc.depend.mk

checksum: download
include ../../mk/spksrc.checksum.mk

extract: checksum depend
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
		{ \
			echo "[build] START: $$(date +%Y%m%d-%H%M%S)" | tee -a $(PSTAT_LOG); \
			$(MAKE) -f $(firstword $(MAKEFILE_LIST)) _all; \
			echo "[build] END: $$(date +%Y%m%d-%H%M%S)" | tee -a $(PSTAT_LOG); \
		} > >(tee -a $(WORK_DIR)/../build-native-$(PKG_NAME).log) 2>&1; \
		[ $${PIPESTATUS[0]} -eq 0 ] || (echo "[build] FAILED" | tee -a $(PSTAT_LOG); exit 1) \
	'

####

### Include common rules
include ../../mk/spksrc.common-rules.mk

###
