PKG_NAME = mutt
PKG_VERS = 1.5.24
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.mutt.org/pub/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/openssl

HOMEPAGE = http://www.mutt.org
COMMENT  = Mutt is a small but very powerful text-based mail client for Unix operating systems.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-ssl=openssl --enable-pop --enable-imap --enable-smtp

INSTALL_TARGET = myInstall
POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)

.PHONY: myPostInstall
myPostInstall:
	cp $(WORK_DIR)/$(PKG_DIR)/doc/Muttrc $(STAGING_INSTALL_PREFIX)/etc/Muttrc
