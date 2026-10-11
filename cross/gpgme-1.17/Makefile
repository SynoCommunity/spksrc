PKG_NAME = gpgme
PKG_VERS = 1.17.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gnupg.org/ftp/gcrypt/gpgme
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Versions newer than 1.17.1 are not compatible with DSM 6 toolchains anymore...

# Pinned to libassuan 2.x: 1.17.1 is incompatible with libassuan 3 (see
# the hold-back note in cross/libassuan-2.5); the virtual would resolve 3.0.
DEPENDS = cross/libgpg-error cross/libassuan-2.5

# Needs gcc >= 4.8: the C++ bindings require C++11 (proven: 4.7.3 fails,
# 4.9.3 builds); older toolchains get no gpgme.
MIN_GCC_VERSION = 4.8

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
