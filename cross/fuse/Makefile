PKG_NAME = fuse
PKG_VERS = 2.9.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/$(PKG_NAME)/files/$(PKG_NAME)-2.X/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://fuse.sourceforge.net/
COMMENT  = File System in User Space
LICENSE  = GNU GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS =  --exec-prefix=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

