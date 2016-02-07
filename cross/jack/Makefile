PKG_NAME = jack
PKG_VERS = 0.124.1
PKG_EXT = tar.gz
PKG_DIR = jack-audio-connection-kit-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://jackaudio.org/downloads/

DEPENDS = cross/berkeleydb cross/libuuid

HOMEPAGE = http:/jackaudio.org/
COMMENT  = Audio connection kit (1)
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --prefix=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

