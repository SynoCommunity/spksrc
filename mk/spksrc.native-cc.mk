# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Force build in native tool directrory, not cross directory.
WORK_DIR := $(PWD)/work-native

# Package dependend
URLS          = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
NAME          = native-$(PKG_NAME) 
COOKIE_PREFIX = $(PKG_NAME)-
DIST_FILE     = $(DISTRIB_DIR)/$(PKG_DIST_NAME)
DIST_EXT      = $(PKG_EXT)

#####

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

.PHONY: cat_PLIST
cat_PLIST:
	@true

### Clean rules
clean:
	rm -fr $(WORK_DIR)

all: compile

