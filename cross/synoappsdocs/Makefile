PKG_NAME = SynoAppsDocs
PKG_VERS = 1.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/DigitalBox98/SynoAppsDocs/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/DigitalBox98/
COMMENT  = Syno Application Docs information

GNU_CONFIGURE = 1

INSTALL_TARGET = synoappsdocs_install

include ../../mk/spksrc.install-resources.mk

.PHONY: synoappsdocs_install
synoappsdocs_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/web 
	tar -xvf $(WORK_DIR)/$(PKG_DIR)/docs/synoappsdocs.tar.gz -C $(STAGING_INSTALL_PREFIX)/web/
