PKG_NAME = haproxy
PKG_VERS = 1.5.14
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.haproxy.org/download/1.5/src
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/zlib

MAINTAINER = SynoCommunity
HOMEPAGE   = http://www.haproxy.org
COMMENT    = HAProxy is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications.
LICENSE    = GNU GPL 2

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall
OFLAG = -O3

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile: 
	$(RUN) $(MAKE) TARGET=generic CPU=generic ARCH= USE_OPENSSL=1 USE_TPROXY=1 USE_PTHREAD_PSHARED=1 USE_ZLIB=1 SPKSRC_CFLAGS="$(CFLAGS) $(OFLAG)" SPKSRC_LDFLAGS="$(LDFLAGS)"

myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)
