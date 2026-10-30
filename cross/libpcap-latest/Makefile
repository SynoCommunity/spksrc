PKG_NAME = libpcap
PKG_VERS = 1.11.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.tcpdump.org/release
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# Requires EFD_NONBLOCK part of eventfd.h
MIN_GLIBC_VERSION = 2.15

HOMEPAGE = https://www.tcpdump.org/
COMMENT  = Portable C/C++ library for network traffic capture.
LICENSE  = BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --with-pcap=linux

# Using -O make ARMv7L to fail on Assembler
#    Error: invalid operands (.text and *UND* sections) for `-'
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
