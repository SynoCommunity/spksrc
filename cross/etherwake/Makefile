PKG_NAME = etherwake
PKG_VERS = 1.09
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).orig.$(PKG_EXT)
PKG_DIST_SITE = https://ftp.debian.org/debian/pool/main/e/etherwake/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS).orig

DEPENDS =

# homepage is not reachable anymore
HOMEPAGE = www.scyld.com/wakeonlan.html
COMMENT  = Generate and transmit a Wake-On-LAN (WOL) Magic Packet
LICENSE  = GPL

CONFIGURE_TARGET = nop

include ../../mk/spksrc.cross-cc.mk
