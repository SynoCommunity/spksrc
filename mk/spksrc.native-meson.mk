# Build CMake programs
#
# prerequisites:
# - native/module depends on meson + ninja
#

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Force build in native tool directrory, not cross directory.
WORK_DIR := $(PWD)/work-native

# Package dependend
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

#####

.NOTPARALLEL:

include ../../mk/spksrc.native-env.mk

# meson specific configurations
include ../../mk/spksrc.native-meson-env.mk

# configure using meson
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = meson_configure_target
endif

.PHONY: meson_configure_target

# default meson configure:
meson_configure_target:
	@$(MSG) - Meson configure
	@$(MSG)    - Dependencies = $(DEPENDS)
	@$(MSG)    - Build path = $(WORK_DIR)/$(PKG_DIR)/$(MESON_BUILD_DIR)
	@$(MSG)    - Configure ARGS = $(CONFIGURE_ARGS)
	@$(MSG)    - Install prefix = $(INSTALL_PREFIX)
	cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV) meson $(MESON_BUILD_DIR) -Dprefix=$(INSTALL_PREFIX) $(CONFIGURE_ARGS)

# call-up ninja build process
include ../../mk/spksrc.cross-ninja.mk

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

### Clean rules
clean:
	rm -fr $(WORK_DIR)

all: install

### For make digests
include ../../mk/spksrc.generate-digests.mk

### For make dependency-tree
include ../../mk/spksrc.dependency-tree.mk

####
