PKG_NAME = M2Crypto
PKG_VERS = 0.22.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/M/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

HOMEPAGE = https://pypi.python.org/pypi/M2Crypto
COMMENT  = A Python crypto and SSL toolkit
LICENSE  =  MIT

ENV += STAGING_INSTALL_PREFIX=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.python-module.mk
