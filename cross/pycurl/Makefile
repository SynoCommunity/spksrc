PKG_NAME = pycurl
PKG_VERS = 7.19.5.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://pycurl.sourceforge.net/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/curl

HOMEPAGE = http://pycurl.sourceforge.net
COMMENT  = PycURL is a Python interface to libcurl
LICENSE  = Dual licensed under the LGPL and an MIT/X derivative license based on the cURL license

BUILD_ARGS   = --curl-config=$(STAGING_INSTALL_PREFIX)/bin/curl-config
INSTALL_ARGS = --curl-config=$(STAGING_INSTALL_PREFIX)/bin/curl-config

include ../../mk/spksrc.python-module.mk

