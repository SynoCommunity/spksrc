PKG_NAME = socat
PKG_VERS = 1.7.3.4
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.dest-unreach.org/socat/download

DEPENDS = cross/openssl

HOMEPAGE = http://www.dest-unreach.org/socat/
COMMENT  = socat - Multipurpose relay \(SOcket CAT)\. Socat is a command line based utility that establishes two bidirectional byte streams and transfers data between them. Because the streams can be constructed from a large set of different types of data sinks and sources, and because lots of address options may be applied to the streams, socat can be used for many different purposes.  
LICENSE  = GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
