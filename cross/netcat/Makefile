PKG_NAME = netcat
PKG_VERS = 0.7.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/netcat/files/netcat/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://netcat.sourceforge.net/
COMMENT  = Netcat is a featured networking utility which reads and writes data across network connections, using the TCP/IP protocol.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
