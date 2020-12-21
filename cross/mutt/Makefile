PKG_NAME = mutt
PKG_VERS = 2.0.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.mutt.org/pub/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/openssl cross/cyrus-sasl

HOMEPAGE = http://www.mutt.org
COMMENT  = Mutt is a small but very powerful text-based mail client for Unix operating systems.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-ssl=openssl --enable-pop --enable-imap --enable-smtp --with-sasl

INSTALL_TARGET = mutt_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: mutt_install
mutt_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
	cp $(WORK_DIR)/$(PKG_DIR)/doc/Muttrc.head $(STAGING_INSTALL_PREFIX)/etc/Muttrc
