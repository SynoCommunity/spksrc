PKG_NAME = haproxy
PKG_VERS = 1.5-dev12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://haproxy.1wt.eu/download/1.5/src/devel
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

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
	$(RUN) $(MAKE) TARGET=generic CC=$(CC) LD=$(CC) ARCH= CPU=generic PREFIX=$(INSTALL_PREFIX) USE_OPENSSL=1 ADDINC=-I${WORK_DIR}/install/usr/local/haproxy/include ADDLIB=-L${WORK_DIR}/install/usr/local/haproxy/lib

myInstall:
	echo "Install"
	@$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) SBINDIR=/usr/local/haproxy/bin

