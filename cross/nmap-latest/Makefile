PKG_NAME = nmap
PKG_VERS = 7.99
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://nmap.org/dist
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpcap cross/openssl3

# latest version for OLD_PPC_ARCHS is 7.92
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)
# latest version for ARMv5 and qoriq is 7.98
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS) $(PPC_ARCHS)

HOMEPAGE = https://nmap.org/
COMMENT  = Nmap ("Network Mapper") is a free and open source utility for network discovery and security auditing.
LICENSE  = https://svn.nmap.org/nmap/COPYING

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --without-zenmap
CONFIGURE_ARGS += --without-ndiff
CONFIGURE_ARGS += --with-liblua=included
CONFIGURE_ARGS += --with-libpcre=included
# openssl prefix from the single source of truth (cross-env.mk scan): the shared
# meta staging if present, else the local staging (cross/openssl3).
CONFIGURE_ARGS += --with-openssl=$(OPENSSL_STAGING_INSTALL_PREFIX)

ADDITIONAL_CPPFLAGS = -O3

include ../../mk/spksrc.cross-cc.mk
