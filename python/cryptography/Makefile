PKG_NAME = cryptography
PKG_VERS = 41.0.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/c/cryptography
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3 cross/libffi

HOMEPAGE = https://github.com/pyca/cryptography
COMMENT  = Provide cryptographic recipes and primitives to Python developers
LICENSE  = BSD/ASL2

include ../../mk/spksrc.python-wheel.mk
