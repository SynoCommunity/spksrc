PKG_NAME = borgbackup
PKG_VERS = 1.1.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/b/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/attr cross/acl cross/openssl

HOMEPAGE = https://borgbackup.readthedocs.io/
COMMENT  = Deduplicating backup program with compression and authenticated encryption
LICENSE  = Borg

ENV += BORG_LZ4_PREFIX="$(STAGING_INSTALL_PREFIX)" BORG_OPENSSL_PREFIX="$(STAGING_INSTALL_PREFIX)"

include ../../mk/spksrc.python-wheel.mk

