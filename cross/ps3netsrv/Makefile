PKG_NAME = ps3netsrv
PKG_VERS = 1.47.08
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/aldostools/webMAN-MOD/archive
PKG_DIR = webMAN-MOD-$(PKG_VERS)/_Projects_/$(PKG_NAME)

DEPENDS =

HOMEPAGE = https://github.com/aldostools/webMAN-MOD
COMMENT = Allows PS3 content to be loaded from network
LICENSE = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS =

CONFIGURE_TARGET = myConfigure
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
		mv $(WORK_DIR)/$(PKG_DIR)/Makefile $(WORK_DIR)/$(PKG_DIR)/Makefile.win
		mv $(WORK_DIR)/$(PKG_DIR)/Makefile.linux $(WORK_DIR)/$(PKG_DIR)/Makefile
		# TODO: Remove it
		#sed -i -e "s|BUILD_TYPE = release|BUILD_TYPE = debug_static|g" $(WORK_DIR)/$(PKG_DIR)/Makefile

.PHONY: myInstall
myInstall:
		@mkdir -p $(STAGING_INSTALL_PREFIX)/bin
		@install -m 755 $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME) $(STAGING_INSTALL_PREFIX)/bin/
