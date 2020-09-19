PKG_NAME = PyNaCl
PKG_VERS = 1.3.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/p/pynacl
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/cffi
DEPENDS = cross/libsodium

HOMEPAGE = https://github.com/pyca/pynacl/
COMMENT  = PyNaCl is a Python binding to libsodium, which is a fork of the Networking and Cryptography library.
LICENSE  = Apache License 2.0

include ../../mk/spksrc.python-wheel.mk

# libsodium shall be taken from the system libraries
ENV += SODIUM_INSTALL=system
