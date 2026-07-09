PKG_NAME = aclk-schemas
PKG_VERS = db1f9d8534aaae75c066955daa24778cd3d587eb
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/netdata/aclk-schemas/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

DEPENDS =

HOMEPAGE = https://github.com/netdata/aclk-schemas
COMMENT  = Protobuf schemas used in ACLK connection
LICENSE  = GPLv3

CONFIGURE_TARGET = aclk_configure
COMPILE_TARGET = aclk_compile
INSTALL_TARGET = aclk_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: aclk_configure aclk_compile aclk_install
aclk_configure aclk_compile aclk_install: ;
