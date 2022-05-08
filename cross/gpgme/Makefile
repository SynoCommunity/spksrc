PKG_NAME = gpgme
PKG_VERS = 1.17.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gnupg.org/ftp/gcrypt/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libgpg-error cross/libassuan

# gcc: unrecognized command line options "-Wno-format-truncation" "-Wno-sizeof-pointer-div"
# this might be solved by a patch...
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://gnupg.org/related_software/gpgme/
COMMENT  = GnuPG Made Easy (GPGME) is a library designed to make access to GnuPG easier for applications. It provides a High-Level Crypto API for encryption, decryption, signing, signature verification and key management..
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-gpg-error-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-libassuan-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --disable-static
# Disable tests that cannot be run with cross compilation
CONFIGURE_ARGS += --disable-glibtest --disable-gpg-test --disable-gpgsm-test

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
