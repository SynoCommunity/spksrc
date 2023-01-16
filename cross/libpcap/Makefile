PKG_NAME = libpcap
PKG_VERS = 1.9.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.tcpdump.org/release
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.tcpdump.org/
COMMENT  = Portable C/C++ library for network traffic capture.
LICENSE  = BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-pcap=linux

include ../../mk/spksrc.cross-cc.mk
