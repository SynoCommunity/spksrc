PKG_NAME = pinentry
PKG_VERS = 0.9.7
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnupg.org/gcrypt/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.gnupg.org/related_software/pinentry/
COMMENT  = pinentry is a small collection of dialog programs that allow GnuPG to read passphrases and PIN numbers in a secure manner. There are versions for the common GTK and Qt toolkits as well as for the text terminal (Curses).
LICENSE  = LGPL

DEPENDS = cross/libassuan cross/libgpg-error cross/ncurses

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-pinentry-curses --disable-pinentry-gtk2 --disable-pinentry-qt --without-x --with-gpg-error-prefix=$(STAGING_INSTALL_PREFIX) 
CONFIGURE_ARGS += --with-libassuan-prefix=$(STAGING_INSTALL_PREFIX) --with-ncurses-include-dir=$(STAGING_INSTALL_PREFIX)


include ../../mk/spksrc.cross-cc.mk
