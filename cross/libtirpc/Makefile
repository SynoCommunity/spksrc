PKG_NAME = libtirpc
PKG_VERS = 0.2.5
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://libtirpc.sourceforge.net/
COMMENT  = Libtirpc is a port of Suns Transport-Independent RPC library to Linux

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-gssapi

include ../../mk/spksrc.cross-cc.mk
