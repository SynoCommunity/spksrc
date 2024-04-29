PKG_NAME = dtv-scan-tables
PKG_VERS = n/a
PKG_EXT = tar.gz
PKG_DIST_NAME = master.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/crazycat69/dtv-scan-tables/archive
PKG_DIST_FILE = $(PKG_NAME).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-master

DEPENDS =

HOMEPAGE = https://github.com/crazycat69/dtv-scan-tables
COMMENT  = Digital TV scan tables.
LICENSE  = GPLv2

INSTALL_MAKE_OPTIONS = DATADIR=$(INSTALL_DIR)/$(INSTALL_PREFIX)/share/tvheadend/data DVBV5DIR=dvb-scan install

include ../../mk/spksrc.install-resources.mk
