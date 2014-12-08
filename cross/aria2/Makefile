PKG_NAME = aria2
PKG_VERS = 1.17.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/aria2/files/stable/$(PKG_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libgcrypt cross/libxml2 cross/c-ares cross/sqlite cross/openssl

HOMEPAGE = http://aria2.sourceforge.net/
COMMENT  = aria2 is a lightweight multi-protocol & multi-source command-line download utility. It supports HTTP/HTTPS, FTP, BitTorrent and Metalink. aria2 can be manipulated via built-in JSON-RPC and XML-RPC interfaces.
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-metalink --enable-torrent --enable-threads=posix --with-xml-prefix=$(STAGING_INSTALL_PREFIX) --with-sqlite3

include ../../mk/spksrc.cross-cc.mk

