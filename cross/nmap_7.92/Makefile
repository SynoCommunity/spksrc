PKG_NAME = nmap
# nmap 7.92 is the latest version for OLD_PPC_ARCHS
PKG_VERS = 7.92
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://nmap.org/dist
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpcap cross/openssl3

HOMEPAGE = https://nmap.org/
COMMENT  = Nmap ("Network Mapper") is a free and open source utility for network discovery and security auditing.
LICENSE  = https://svn.nmap.org/nmap/COPYING

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-zenmap --with-liblua=included --with-libpcre=included
ADDITIONAL_CPPFLAGS = -O3

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
ADDITIONAL_CPPFLAGS += -DLUA_32BITS
endif

include ../../mk/spksrc.cross-cc.mk
