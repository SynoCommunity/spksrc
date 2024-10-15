PKG_NAME = libpcap
PKG_VERS = 1.10.5
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.tcpdump.org/release
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# latest version for OLD_PPC_ARCHS and ARMv5 is 1.9.1
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)
# latest version for ARMv7L is 1.10.4
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)

HOMEPAGE = https://www.tcpdump.org/
COMMENT  = Portable C/C++ library for network traffic capture.
LICENSE  = BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --with-pcap=linux
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
