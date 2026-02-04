PKG_NAME = synology-autorun
PKG_VERS = 1.10.0.0011
PKG_EXT = tar.gz
PKG_DIST_NAME = V$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/schmidhorst/synology-autorun/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/schmidhorst/synology-autorun
COMMENT  = Executes a script on external drive \(USB / eSATA\) when it\'s connected to the disk station.
LICENSE  = 3-clause BSD

INSTALL_TARGET = synology-autorun_install

include ../../mk/spksrc.install-resources.mk

.PHONY: synology-autorun_install
synology-autorun_install:
	@$(MSG) Extract the whole package
	@tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)
