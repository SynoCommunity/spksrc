PKG_NAME = cryptography
PKG_VERS = 1.7.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/c/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/cffi

HOMEPAGE = https://github.com/pyca/cryptography
COMMENT  = cryptography is a package which provides cryptographic recipes and primitives to Python developers
LICENSE  = BSD/Apachev2

include ../../mk/spksrc.python-module.mk
