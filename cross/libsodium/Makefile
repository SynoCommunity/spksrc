PKG_NAME = libsodium
PKG_VERS = 1.0.7
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.libsodium.org/libsodium/releases

DEPENDS =

HOMEPAGE = http://doc.libsodium.org/
COMMENT  = Sodium is a modern, easy-to-use software library for encryption, decryption, signatures, password hashing and more
LICENSE  = ISC

GNU_CONFIGURE = 1
DOWNLOAD_ARGS = --no-check-certificate

include ../../mk/spksrc.cross-cc.mk
