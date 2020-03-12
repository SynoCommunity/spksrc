PKG_NAME = htop
PKG_VERS = 2.2.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://hisham.hm/htop/releases/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

UNSUPPORTED_ARCHS = powerpc ppc824x

DEPENDS = cross/ncursesw

HOMEPAGE = http://hisham.hm/htop/
COMMENT  = An interactive process viewer for Linux. The package is intended for DSM-5.0 or earlier where it\'s not available.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --enable-unicode
CONFIGURE_ARGS += HTOP_NCURSESW6_CONFIG_SCRIPT=$(STAGING_INSTALL_PREFIX)/bin/ncursesw6-config
CONFIGURE_ARGS += --disable-dependency-tracking


include ../../mk/spksrc.cross-cc.mk
