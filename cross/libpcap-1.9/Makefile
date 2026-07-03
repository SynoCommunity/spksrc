PKG_NAME = libpcap
PKG_VERS = 1.9.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.tcpdump.org/release
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# this is the latests version that builds for OLD_PPC_ARCHS
# we use this version for ARMv5 since newer versions are not working (#6256)
# we use this version for ARMv7L since versions > 1.10.4 fail to build

DEPENDS =

HOMEPAGE = https://www.tcpdump.org/
COMMENT  = Portable C/C++ library for network traffic capture.
LICENSE  = BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --with-pcap=linux
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
