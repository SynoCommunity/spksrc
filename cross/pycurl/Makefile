PKG_NAME = pycurl
PKG_VERS = 7.43.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/p/pycurl
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/curl

HOMEPAGE = http://pycurl.sourceforge.net
COMMENT  = PycURL is a Python interface to libcurl
LICENSE  = Dual licensed under the LGPL and an MIT/X derivative license based on the cURL license

ENV += PYCURL_CURL_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/curl-config

include ../../mk/spksrc.python-wheel.mk
