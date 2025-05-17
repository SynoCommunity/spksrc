PKG_NAME = metacubexd
PKG_VERS = 1.186.1
PKG_EXT = tgz
PKG_DIST_NAME = compressed-dist.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/MetaCubeX/metacubexd/releases/download/v$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/MetaCubeX/metacubexd
COMMENT  = Mihomo Dashboard, The Official One, XD
LICENSE  = GPLv3

EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

INSTALL_TARGET = metacubexd_custom_install

include ../../mk/spksrc.install-resources.mk

.PHONY: metacubexd_custom_install
metacubexd_custom_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/web
	tar -cf - -C $(EXTRACT_PATH) . | tar -xf - -C "$(STAGING_INSTALL_PREFIX)/web"
