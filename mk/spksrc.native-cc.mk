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

.PHONY: cat_PLIST
cat_PLIST:
	@true

all: install

####

### Include common rules
include ../../mk/spksrc.common-rules.mk

###
