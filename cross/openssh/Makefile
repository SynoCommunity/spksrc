PKG_NAME = openssh
PKG_VERS = 9.0p1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.fr.openbsd.org/pub/OpenBSD/OpenSSH/portable
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl

HOMEPAGE = https://www.openssh.com/
COMMENT  = Open source version of SSH connectivity tools.
LICENSE  = BSD-style

GNU_CONFIGURE = 1
INSTALL_MAKE_OPTIONS = install-nosysconf DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)
POST_INSTALL_TARGET = openssh_post_install

CONFIGURE_ARGS = --with-privsep-path=$(INSTALL_PREFIX)/var/empty
CONFIGURE_ARGS += --disable-lastlog --disable-strip
CONFIGURE_ARGS += --disable-utmp --disable-utmpx
CONFIGURE_ARGS += --disable-wtmp --disable-wtmpx

include ../../mk/spksrc.cross-cc.mk

.PHONY: openssh_post_install
openssh_post_install:
	cd $(STAGING_INSTALL_PREFIX)/bin && ln -sf ssh slogin
