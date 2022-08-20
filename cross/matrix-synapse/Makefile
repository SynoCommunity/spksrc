PKG_NAME = matrix-synapse
PKG_VERS = 1.64.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/m/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/sqlite

HOMEPAGE = https://matrix.org/
COMMENT  = Synapse: Matrix reference homeserver.
LICENSE  = Apache 2.0

include ../../mk/spksrc.python-wheel.mk
