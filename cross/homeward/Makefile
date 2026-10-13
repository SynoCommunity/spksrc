PKG_NAME = homeward
PKG_VERS = 0.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sebiweise/homeward/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/sebiweise/homeward
COMMENT  = DSM app (UI and JSON API endpoint) of Homeward. The Python code itself is installed as a wheel from PyPI.
LICENSE  = MIT

INSTALL_TARGET = homeward_install_ui

include ../../mk/spksrc.cross-install.mk

.PHONY: homeward_install_ui
homeward_install_ui:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/ui
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/package/ui . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/ui
