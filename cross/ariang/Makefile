PKG_NAME = ariang
PKG_VERS = 1.3.7
PKG_EXT = zip
PKG_DIST_NAME = AriaNg-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mayswind/AriaNg/releases/download/$(PKG_VERS)
PKG_DIR = AriaNg-$(PKG_VERS)

HOMEPAGE = http://ariang.mayswind.net/
COMMENT  = AriaNg, a modern web frontend making aria2 easier to use.
LICENSE  = MIT

# We must override EXTRACT_PATH because the package extracts to the containing folder
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

INSTALL_TARGET = ariang_install

include ../../mk/spksrc.install-resources.mk

.PHONY: ariang_install
ariang_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/web
	cp -R $(WORK_DIR)/$(PKG_DIR)/* $(STAGING_INSTALL_PREFIX)/web/
