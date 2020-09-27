PKG_NAME = nmap
PKG_VERS = 7.80
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://nmap.org/dist
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpcap cross/openssl

HOMEPAGE = https://nmap.org/
COMMENT  = Nmap ("Network Mapper") is a free and open source utility for network discovery and security auditing
LICENSE  = https://svn.nmap.org/nmap/COPYING

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-zenmap --without-ncat --with-liblua=included --with-libpcre=included
# needed for compilation to avoid warning "_FORTIFY_SOURCE requires compiling with optimization (-O)"
ADDITIONAL_CPPFLAGS = -O3

include ../../mk/spksrc.cross-cc.mk
