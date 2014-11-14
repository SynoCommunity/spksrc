PKG_NAME = bcusdk
PKG_VERS = 0.0.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.auto.tuwien.ac.at/~mkoegler/eib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/pthsem

HOMEPAGE = http://www.auto.tuwien.ac.at/~mkoegler/index.php/bcusdk
COMMENT  = A free development environment for BCU1 and BCU2
LICENSE  = GNU GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-shared=no --with-pth=$(STAGING_INSTALL_PREFIX) --without-pth-test --enable-onlyeibd --enable-eibnetip --enable-eibnetiptunnel --enable-eibnetipserver --enable-usb

include ../../mk/spksrc.cross-cc.mk
