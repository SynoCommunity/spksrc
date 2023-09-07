PKG_NAME = DTLSSocket
PKG_VERS = 0.1.16
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/58/42/0a0442118096eb9fbc9dc70b45aee2957f7546b80545e2a05bd839380519
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/cython

HOMEPAGE = https://git.fslab.de/jkonra2m/tinydtls-cython
COMMENT  = DTLSSocket is a Cython wrapper for tinydtls with a Socket like interface.
LICENSE  = Eclipse Public License 1.0

PRE_CONFIGURE_TARGET = dtlssocket_pre_configure

include ../../mk/spksrc.python-wheel.mk

.PHONY: dtlssocket_pre_configure
dtlssocket_pre_configure:
	@$(MSG) configure tinydtls to cross compile
	@$(RUN) sed -i.bak 's%"\./configure"%"\./configure --host=$(TC_TARGET) --build=i686-pc-linux"%g' setup.py
