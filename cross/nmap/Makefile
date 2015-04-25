PKG_NAME = nmap
PKG_VERS = 6.47
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://nmap.org/dist
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpcap cross/openssl

HOMEPAGE = https://nmap.org/
COMMENT  = Nmap ("Network Mapper") is a free and open source (license) utility for network discovery and security auditing
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-zenmap --without-ncat --with-liblua=included --with-libpcre=included CFLAGS=$(TC_CFLAGS)

include ../../mk/spksrc.cross-cc.mk
