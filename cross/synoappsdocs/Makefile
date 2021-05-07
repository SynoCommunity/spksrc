PKG_NAME = SynoAppsDocs
PKG_VERS = 1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/DigitalBox98/SynoAppsDocs/releases/download/v1.0/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/DigitalBox98/
COMMENT  = Syno Application Docs information

GNU_CONFIGURE = 1

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = synoappsdocs_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: synoappsdocs_install
synoappsdocs_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/apps
	tar -xvf $(WORK_DIR)/$(PKG_DIR)/docs/synoappsdocs.tar.gz -C $(STAGING_INSTALL_PREFIX)/apps/
