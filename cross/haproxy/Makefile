PKG_NAME = haproxy
PKG_VERS = 1.5~ss20121019
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-ss-20121019.$(PKG_EXT)
PKG_DIST_SITE = http://haproxy.1wt.eu/download/1.5/src/snapshot
PKG_DIR = $(PKG_NAME)-ss-20121019

DEPENDS = cross/openssl

MAINTAINER = SynoCommunity
HOMEPAGE   = http://haproxy.1wt.eu/
COMMENT    = HAProxy is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications.
LICENSE    = GNU GPL 2

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile: 
	$(RUN) $(MAKE) TARGET=generic CPU=generic ARCH= USE_OPENSSL=1

myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)

