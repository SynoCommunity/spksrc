PKG_NAME = haproxy
PKG_VERS = 1.5.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://haproxy.1wt.eu/download/1.5/src
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

MAINTAINER = SynoCommunity
HOMEPAGE   = http://haproxy.1wt.eu/
COMMENT    = HAProxy is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications.
LICENSE    = GNU GPL 2

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall
OFLAG = -O3

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile: 
	$(RUN) $(MAKE) TARGET=generic CPU=generic ARCH= USE_OPENSSL=1 USE_TPROXY=1 USE_PTHREAD_PSHARED=1 SPKSRC_CFLAGS="$(CFLAGS) $(OFLAG)" SPKSRC_LDFLAGS="$(LDFLAGS)"

myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)
