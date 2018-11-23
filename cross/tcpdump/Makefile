PKG_NAME = tcpdump
PKG_VERS = 4.9.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.tcpdump.org/release
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpcap

HOMEPAGE = http://www.tcpdump.org/
COMMENT  = Packet Capture program
LICENSE  = BSD

GNU_CONFIGURE = 1
#CONFIGURE_ARGS = --with-pcap=linux


include ../../mk/spksrc.cross-cc.mk
