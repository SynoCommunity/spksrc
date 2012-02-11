
PKG_NAME = libffi
PKG_VERS = 3.0.10
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://sourceware.org/pub/$(PKG_NAME)

DEPENDS = 

MAINTAINER = packages@packages.nas-forum.com
HOMEPAGE   = http://sourceware.org/libffi/
COMMENT    = A Portable Foreign Function Interface Library
LICENSE    = 

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = myPreConfigure
INSTALL_TARGET = myInstall
 
include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) automake

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR) prefix=$(STAGING_INSTALL_PREFIX)

