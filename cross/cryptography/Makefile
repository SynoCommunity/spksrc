PKG_NAME = cryptography
PKG_VERS = 1.2.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/c/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/cffi cross/enum34 cross/six
DEPENDS += cross/idna cross/ipaddress cross/pyasn1

HOMEPAGE = https://github.com/pyca/cryptography
COMMENT  = cryptography is a package which provides cryptographic recipes and primitives to Python developers
LICENSE  = BSD/Apachev2

include ../../mk/spksrc.python-module.mk
