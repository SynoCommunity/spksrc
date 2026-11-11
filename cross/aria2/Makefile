PKG_NAME = aria2
PKG_VERS = 1.37.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/aria2/aria2/releases/download/release-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3 cross/libssh2 cross/libexpat cross/c-ares cross/sqlite

# C++11: configure stops on gcc 4.7.3 and older ("A compiler with support for C++11
# language features is required").
MIN_GCC_VERSION = 4.8

HOMEPAGE = https://aria2.github.io/
COMMENT  = aria2 is a lightweight multi-protocol & multi-source command-line download utility. It supports HTTP/HTTPS, FTP, SFTP, BitTorrent and Metalink.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt
CONFIGURE_ARGS += --with-sqlite3
# There is an issue with gnutls on ARMv8 archs
# ensure gnutls and libgcrypt are ignored when found
CONFIGURE_ARGS += --without-gnutls
CONFIGURE_ARGS += --without-libgcrypt

include ../../mk/spksrc.cross-cc.mk
