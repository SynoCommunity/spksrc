PKG_NAME = dropbear
PKG_VERS = 2013.58
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://matt.ucc.asn.au/dropbear/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = https://matt.ucc.asn.au/dropbear/dropbear.html
COMMENT  = Dropbear is a relatively small SSH server and client.
LICENSE  = MIT

GNU_CONFIGURE = 1

COMPILE_MAKE_OPTIONS += PROGRAMS="dropbear scp dbclient dropbearkey dropbearconvert"
COMPILE_MAKE_OPTIONS += DSS_PRIV_FILENAME=$(INSTALL_PREFIX)/etc/dropbear/dropbear_dss_host_key
COMPILE_MAKE_OPTIONS += RSA_PRIV_FILENAME=$(INSTALL_PREFIX)/etc/dropbear/dropbear_rsa_host_key
COMPILE_MAKE_OPTIONS += MAX_AUTH_TRIES=3
COMPILE_MAKE_OPTIONS += DROPBEAR_PIDFILE=$(INSTALL_PREFIX)/var/dropbear.pid
COMPILE_MAKE_OPTIONS += DEFAULT_PATH=$(DROPBEAR_DEFAULT_PATH)
COMPILE_MAKE_OPTIONS += _PATH_SSH_PROGRAM=$(INSTALL_PREFIX)/bin/dbclient

INSTALL_TARGET = dropbear_install_target

include ../../mk/spksrc.cross-cc.mk

.PHONY: dropbear_install_target
dropbear_install_target:
	$(RUN) $(MAKE) PROGRAMS="dropbear scp dbclient dropbearkey dropbearconvert" DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX) install
