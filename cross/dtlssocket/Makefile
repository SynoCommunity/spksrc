PKG_NAME = DTLSSocket
PKG_VERS = 0.1.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/35/42/4e2d2c03e6194d4b82dbd921e18a49e5ef113840f76cc8d0a7e6c5cb810c
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/cython

HOMEPAGE = https://git.fslab.de/jkonra2m/tinydtls-cython
COMMENT  = DTLSSocket is a Cython wrapper for tinydtls with a Socket like interface
LICENSE  = Eclipse Public License 1.0

PRE_CONFIGURE_TARGET = dtlssocket_pre_configure

include ../../mk/spksrc.python-wheel.mk

.PHONY: dtlssocket_pre_configure
# configure tinydtls to cross compile
dtlssocket_pre_configure:
	@$(RUN) sed -i 's%"\./configure", "--without-ecc"%"\./configure", "--without-ecc", "--host=$(TC_TARGET)", "--build=i686-pc-linux"%g' setup.py
