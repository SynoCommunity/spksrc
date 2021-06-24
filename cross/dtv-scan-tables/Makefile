PKG_NAME = dtv-scan-tables
PKG_VERS = na
PKG_EXT = tar.gz
PKG_DIST_NAME = master.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/crazycat69/dtv-scan-tables/archive
PKG_DIST_FILE = $(PKG_NAME).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-master

DEPENDS =

INSTALL_TARGET = dtv_scan_tables_install

HOMEPAGE = https://github.com/crazycat69/dtv-scan-tables
COMMENT  = Digital TV scan tables
LICENSE  = GPLv2

include ../../mk/spksrc.install-resources.mk

.PHONY: dtv_scan_tables_install
dtv_scan_tables_install:
	$(RUN) DATADIR=$(INSTALL_DIR)/$(INSTALL_PREFIX)/share/tvheadend/data DVBV5DIR=dvb-scan $(MAKE) install
