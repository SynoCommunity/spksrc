PKG_NAME = cryptography
PKG_VERS = 40.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/c/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/cffi

HOMEPAGE = https://github.com/pyca/cryptography
COMMENT  = Provide cryptographic recipes and primitives to Python developers
LICENSE  = BSD/ASL2

###
### This cross/cryptography is needed to generate python-limited abi3 wheels
### Ref: https://github.com/pyca/cryptography/issues/7671
###

WHEELS_BUILD_ARGS = --py-limited-api=$(PYTHON_LIMITED_API)

# Mandatory PYO3_* variables for rust cross-compiling
ENV += PYO3_CROSS_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
ENV += PYO3_CROSS_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/
# Mandatory of using OPENSSL_*_DIR starting with
# cryptography version >= 40
# https://docs.rs/openssl/latest/openssl/#automatic
ENV += OPENSSL_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
ENV += OPENSSL_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/

include ../../mk/spksrc.python-wheel.mk
