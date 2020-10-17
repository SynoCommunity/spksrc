PKG_NAME = ntfs-3g_ntfsprogs
PKG_VERS = 2017.3.23
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://tuxera.com/opensource
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.tuxera.com/community/open-source-ntfs-3g/
COMMENT  = ntfs-3g – Third Generation Read/Write NTFS Driver.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --prefix=$(INSTALL_PREFIX) --exec-prefix=$(INSTALL_PREFIX)


include ../../mk/spksrc.cross-cc.mk
