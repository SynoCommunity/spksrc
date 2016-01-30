PKG_NAME = libupnp
PKG_VERS = 1.6.19
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/pupnp/files/pupnp/libUPnP%20$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://sourceforge.net/projects/pupnp/
COMMENT  = The portable Universal Plug and Play (UPnP) SDK provides support for building UPnP-compliant control points, devices, and bridges on several operating systems
LICENSE  = 

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk
