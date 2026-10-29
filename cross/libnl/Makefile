PKG_NAME = libnl
PKG_VERS = 3.11.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/thom311/libnl/releases/download/libnl$(subst .,_,$(PKG_VERS))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/thom311/libnl
COMMENT  = Netlink Protocol Library Suite: APIs to the netlink based kernel interfaces.
LICENSE  = LGPLv2.1

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --disable-cli --disable-debug

include ../../mk/spksrc.cross-cc.mk
