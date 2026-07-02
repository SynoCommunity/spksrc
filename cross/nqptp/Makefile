PKG_NAME = nqptp
PKG_VERS = 1.2.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mikebrady/nqptp/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/mikebrady/nqptp
COMMENT  = Network Quasi-Precision Time Protocol daemon for AirPlay 2
LICENSE  = GPL

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = nqptp_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: nqptp_pre_configure
nqptp_pre_configure:
	$(RUN) autoreconf -i -f
