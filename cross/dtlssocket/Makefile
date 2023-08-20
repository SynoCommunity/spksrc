PKG_NAME = DTLSSocket
PKG_VERS = 0.1.15
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/72/dc/8171d3106233efbd28620539594ca705f1aa9e140287823e23cd46ca7c42
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
