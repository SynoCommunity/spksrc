PKG_NAME = dropbear
PKG_VERS = 2013.56
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://matt.ucc.asn.au/dropbear/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = https://matt.ucc.asn.au/dropbear/dropbear.html
COMMENT  = Dropbear is a relatively small SSH server and client.
LICENSE  = MIT

GNU_CONFIGURE = 1

COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

CONFIGURE_ARGS = --disable-largefile --disable-openpty --disable-syslog --disable-shadow --disable-lastlog --disable-utmp --disable-utmpx --disable-wtmp --disable-wtmpx --disable-loginfunc --disable-pututline --disable-pututxline

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE) PROGRAMS="dropbear scp dropbearkey dropbearconvert"

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) PROGRAMS="dropbear scp dropbearkey dropbearconvert" DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX) install
