PKG_NAME = progsreiserfs
PKG_VERS = 0.3.1-rc8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.mirrorservice.org/sites/download.salixos.org/x86_64/13.37/source/ap/testdisk
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://reiserfs.osdn.org.ua/
COMMENT  = reiserfs library for testdisk utilities.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-Werror

include ../../mk/spksrc.cross-cc.mk
