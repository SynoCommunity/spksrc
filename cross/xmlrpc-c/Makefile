PKG_NAME = xmlrpc-c
PKG_VERS = 1.51.06
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/$(PKG_NAME)/files/Xmlrpc-c%20Super%20Stable/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/curl

HOMEPAGE = http://xmlrpc-c.sourceforge.net/
COMMENT  = Programming library for writing an XML-RPC server or client in C or C++.
LICENSE  = BSD

PRE_CONFIGURE_TARGET = xmlrpc-c_pre_configure
GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-libxml2-backend

ENV += PATH=$(INSTALL_DIR)/$(INSTALL_PREFIX)/bin:$$PATH

include ../../mk/spksrc.cross-cc.mk

.PHONY: xmlrpc-c_pre_configure
xmlrpc-c_pre_configure:
	cp $(STAGING_INSTALL_PREFIX)/lib/libxml2.* $(WORK_DIR)/$(PKG_DIR)/lib/libutil/
	cp $(STAGING_INSTALL_PREFIX)/lib/libcurl.* $(WORK_DIR)/$(PKG_DIR)/lib/libutil/
