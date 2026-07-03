PKG_NAME = xmlrpc-c
PKG_VERS = 1.60.05
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/xmlrpc-c/files/Xmlrpc-c%20Super%20Stable/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/curl

HOMEPAGE = http://xmlrpc-c.sourceforge.net/
COMMENT  = Programming library for writing an XML-RPC server or client in C or C++.
LICENSE  = BSD

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-libxml2-backend

# Limit parallelism for xmlrpc-c; avoid races in libxmlrpc_util.so build
DISABLE_PARALLEL_MAKE = 1

# requires xml2-config in path to build libxml2-backend
ENV += PATH=$(INSTALL_DIR)/$(INSTALL_PREFIX)/bin:$$PATH

POST_INSTALL_TARGET = xmlrpc_c_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: xmlrpc_c_post_install
xmlrpc_c_post_install:
	# make xmlrpc-c-config use xml2-config from the same dir
	sed -i -e 's|LIBXML=`xml2-config --libs`|LIBXML=`"$$\(dirname "$$0")/xml2-config" --libs`|' \
		$(STAGING_INSTALL_PREFIX)/bin/xmlrpc-c-config
