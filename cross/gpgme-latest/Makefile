PKG_NAME = gpgme
PKG_VERS = 1.24.3
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gnupg.org/ftp/gcrypt/gpgme
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Needs gcc >= 5: the C++ bindings use brace-init conversions rejected by
# gcc 4.x (proven: 4.7.3/4.9.3 fail, 7.5+ build); older toolchains stay frozen.
MIN_GCC_VERSION = 5

DEPENDS = cross/libgpg-error cross/libassuan

HOMEPAGE = https://gnupg.org/related_software/gpgme/
COMMENT  = GnuPG Made Easy (GPGME) is a library designed to make access to GnuPG easier for applications. It provides a High-Level Crypto API for encryption, decryption, signing, signature verification and key management..
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-libgpg-error-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-libassuan-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --disable-static
# Disable tests that cannot be run with cross compilation
CONFIGURE_ARGS += --disable-glibtest --disable-gpg-test --disable-gpgsm-test

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
