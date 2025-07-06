PKG_NAME = dtv-scan-tables
# There are no releases available. We take the current master in the github repository.
# PKG_VERS: date of the latest commit, adjust it when master got updates.
PKG_VERS = 2025.02.11
PKG_EXT = tar.gz
PKG_DIST_NAME = master.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/crazycat69/dtv-scan-tables/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-master

DEPENDS =

HOMEPAGE = https://github.com/crazycat69/dtv-scan-tables
COMMENT  = Digital TV scan tables.
LICENSE  = GPLv2

INSTALL_MAKE_OPTIONS = DATADIR=$(STAGING_INSTALL_PREFIX)/share/tvheadend/data DVBV5DIR=dvb-scan install

include ../../mk/spksrc.install-resources.mk
