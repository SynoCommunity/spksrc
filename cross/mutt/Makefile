PKG_NAME = mutt
PKG_VERS = 2.2.13
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.mutt.org/pub/mutt
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/openssl3 cross/cyrus-sasl

HOMEPAGE = http://www.mutt.org
COMMENT  = Mutt is a small but very powerful text-based mail client for Unix operating systems.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-ssl=openssl
CONFIGURE_ARGS += --enable-pop
CONFIGURE_ARGS += --enable-imap
CONFIGURE_ARGS += --enable-smtp
CONFIGURE_ARGS += --with-sasl
CONFIGURE_ARGS += --disable-doc
CONFIGURE_ARGS += --sysconfdir=$(INSTALL_PREFIX)/var

INSTALL_TARGET = mutt_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: mutt_install
mutt_install:
	@$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/var
	cp $(WORK_DIR)/$(PKG_DIR)/doc/Muttrc.head $(STAGING_INSTALL_PREFIX)/var/Muttrc
