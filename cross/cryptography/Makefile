PKG_NAME = cryptography
# Last version that can be built using setup.py
PKG_VERS = 41.0.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/c/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3 cross/cffi

HOMEPAGE = https://github.com/pyca/cryptography
COMMENT  = Provide cryptographic recipes and primitives to Python developers
LICENSE  = BSD/ASL2

###
### This cross/cryptography is needed to generate python-limited abi3 wheels
### Ref: https://github.com/pyca/cryptography/issues/7671
###

WHEELS_BUILD_ARGS = --py-limited-api=$(PYTHON_LIMITED_API)

include ../../mk/spksrc.python-wheel.mk
