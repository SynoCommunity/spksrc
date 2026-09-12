PKG_NAME = element
PKG_VERS = v1.11.17
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/vector-im/element-web/releases/download/$(PKG_VERS)
PKG_DIR =  $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://element.io/
COMMENT  = A glossy Matrix collaboration client for the web.
LICENSE  = Apache 2.0

INSTALL_TARGET = element_install

include ../../mk/spksrc.install-resources.mk

.PHONY: element_install
element_install:
	@install -d -m 755 $(STAGING_INSTALL_PREFIX)/web
	@tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/web/
