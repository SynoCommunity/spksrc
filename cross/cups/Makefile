PKG_NAME = cups
PKG_VERS = 2.3.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-source.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/apple/$(PKG_NAME)/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

HOMEPAGE = https://www.cups.org/
COMMENT  = CUPS printing system
LICENSE  = GPLv2

PRE_CONFIGURE_TARGET = cups_pre_configure
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-cupsd-file-perm=0755 \
	--with-log-file-perm=0600 \
	--enable-relro \
        --enable-threads \
        --enable-gnutls \
        --enable-webif \
        --with-xinetd=no \
        --with-access-log-level=actions \
        --enable-page-logging \
	'LDFLAGS=-Wl,-rpath,$(STAGING_INSTALL_PREFIX)/lib'

PATCHES_LEVEL = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: cups_pre_configure
cups_pre_configure:
	$(RUN) aclocal -I config-scripts ; \
	$(RUN) autoconf -f -I config-scripts ; \
