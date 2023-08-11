PKG_NAME = lldpd
PKG_VERS = 1.0.10
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://media.luffy.cx/files/lldpd
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://lldpd.github.io
COMMENT  = lldpd is a 802.1AB implementation (LLDP) to help you locate neighbors of all your equipments
LICENSE  = ISC

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-privsep --disable-cdp --disable-fdp --disable-edp --disable-sonmp --with-privsep-user=sc-lldpd --with-privsep-group=lldpd
include ../../mk/spksrc.cross-cc.mk
