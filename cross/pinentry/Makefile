PKG_NAME = pinentry
PKG_VERS = 1.2.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.gnupg.org/ftp/gcrypt/pinentry
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.gnupg.org/related_software/pinentry/
COMMENT  = pinentry is a small collection of dialog programs that allow GnuPG to read passphrases and PIN numbers in a secure manner.
LICENSE  = LGPLv2+

DEPENDS = cross/ncursesw cross/libassuan cross/libgpg-error

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-pinentry-curses
CONFIGURE_ARGS += --enable-pinentry-tty
CONFIGURE_ARGS += --disable-pinentry-gtk2
CONFIGURE_ARGS += --disable-pinentry-qt
CONFIGURE_ARGS += --with-ncurses-include-dir=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-libassuan-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-gpg-error-prefix=$(STAGING_INSTALL_PREFIX) 
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
