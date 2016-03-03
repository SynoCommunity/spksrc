PKG_NAME = gnupg
PKG_VERS = 2.1.6
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnupg.org/gcrypt/$(PKG_NAME)

DEPENDS  = cross/gnutls cross/libassuan cross/libgcrypt
DEPENDS += cross/libgpg-error cross/libksba cross/npth cross/pinentry

HOMEPAGE = http://www.gnupg.org/
COMMENT  = GnuPG allows to encrypt and sign your data and communication, features a versatile key management system as well as access modules for all kinds of public key directories.
LICENSE  = GNU General Public License

PRE_CONFIGURE_TARGET = myPreConfigure
CONFIGURE_ARGS = --with-gpg-error-prefix=$(STAGING_INSTALL_PREFIX) --with-libgcrypt-prefix=$(STAGING_INSTALL_PREFIX) --with-libassuan-prefix=$(STAGING_INSTALL_PREFIX) --with-ksba-prefix=$(STAGING_INSTALL_PREFIX) --with-npth-prefix=$(STAGING_INSTALL_PREFIX)
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) ACLOCAL_FLAGS="-I /usr/share/aclocal" ./autogen.sh
