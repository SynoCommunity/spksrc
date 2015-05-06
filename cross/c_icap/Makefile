PKG_NAME = c_icap
PKG_VERS = 0.3.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/c-icap/c-icap/0.3.x
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://c-icap.sourceforge.net/
COMMENT  = c-icap is an implementation of an ICAP server. It can be used with HTTP proxies that support the ICAP protocol to implement content adaptation and filtering services.
LICENSE  = 

PRE_CONFIGURE_TARGET = myConfigure
GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-large-files --with-zlib=$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib -C

include ../../mk/spksrc.cross-cc.mk

myConfigure:
	cp patches/config.cache $(WORK_DIR)/$(PKG_DIR)
	cd $(WORK_DIR)/$(PKG_DIR);autoconf
