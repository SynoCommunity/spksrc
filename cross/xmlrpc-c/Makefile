PKG_NAME = xmlrpc-c
PKG_VERS = 1.39.07
PKG_EXT = tgz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_SITE = http://sourceforge.net/projects/$(PKG_NAME)/files/Xmlrpc-c%20Super%20Stable/$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)

DEPENDS = cross/libxml2 cross/curl

HOMEPAGE = http://xmlrpc-c.sourceforge.net/
COMMENT  = Programming library for writing an XML-RPC server or client in C or C++.
LICENSE  = BSD

PRE_CONFIGURE_TARGET = myPreConfigure
GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-libxml2-backend

ENV += PATH=$(INSTALL_DIR)/$(INSTALL_PREFIX)/bin:$$PATH

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	cp $(STAGING_INSTALL_PREFIX)/lib/libxml2.* $(WORK_DIR)/$(PKG_DIR)/lib/libutil/
	cp $(STAGING_INSTALL_PREFIX)/lib/libcurl.* $(WORK_DIR)/$(PKG_DIR)/lib/libutil/
