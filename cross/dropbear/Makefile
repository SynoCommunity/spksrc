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

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE) PROGRAMS="dropbear scp dbclient dropbearkey dropbearconvert" DSS_PRIV_FILENAME=$(INSTALL_PREFIX)/etc/dropbear/dropbear_dss_host_key RSA_PRIV_FILENAME=$(INSTALL_PREFIX)/etc/dropbear/dropbear_rsa_host_key MAX_AUTH_TRIES=3 DROPBEAR_PIDFILE=$(INSTALL_PREFIX)/var/dropbear.pid DEFAULT_PATH=$(DROPBEAR_DEFAULT_PATH) _PATH_SSH_PROGRAM=$(INSTALL_PREFIX)/bin/dbclient

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) PROGRAMS="dropbear scp dbclient dropbearkey dropbearconvert" DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX) install
