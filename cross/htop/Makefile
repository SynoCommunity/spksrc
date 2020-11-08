PKG_NAME = htop
PKG_VERS = 3.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://bintray.com/htop/source/download_file?file_path=
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

UNSUPPORTED_ARCHS = powerpc ppc824x

DEPENDS = cross/ncursesw

HOMEPAGE = https://hisham.hm/htop/
COMMENT  = An interactive process viewer for Linux. The package is intended for DSM-5.0 or earlier where it\'s not available.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --enable-unicode
CONFIGURE_ARGS += HTOP_NCURSESW6_CONFIG_SCRIPT=$(STAGING_INSTALL_PREFIX)/bin/ncursesw6-config
CONFIGURE_ARGS += --disable-dependency-tracking

include ../../mk/spksrc.cross-cc.mk
