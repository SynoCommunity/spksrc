PKG_NAME = e2fsprogs
PKG_VERS = 1.45.4
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)/v$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)

DEPENDS =

HOMEPAGE = http://e2fsprogs.sourceforge.net/
COMMENT  = Ext2/3/4 filesystem userspace utilities
LICENSE  = GPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.common.mk

# This is more a toolchain than an arch limitation
ifeq ($(findstring $(ARCH),ppc853x),$(ARCH))
CONFIGURE_ARGS = --disable-defrag
PLIST_TRANSFORM = sed -e '/bin:sbin\/e4defrag/d'
endif

include ../../mk/spksrc.cross-cc.mk
