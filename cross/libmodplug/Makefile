PKG_NAME = libmodplug
PKG_VERS = 0.8.8.5
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/modplug-xmms/files/$(PKG_NAME)/$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://modplug-xmms.sourceforge.net/
COMMENT  = Modplug-XMMS is a library (libmodplug) and input-plugin for XMMS which plays mod-like music formats. It is based on code by Olivier Lapicque in MODPLug.com.
LICENSE  = 

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --enable-shared

include ../../mk/spksrc.cross-cc.mk

