PKG_NAME = pycrypto
PKG_VERS = 2.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://pypi.python.org/packages/source/p/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.dlitz.net/software/pycrypto/
COMMENT  = Cryptographic modules for Python
LICENSE  = Public domain

ENV += cross_compiling=yes

include ../../mk/spksrc.python-module.mk

