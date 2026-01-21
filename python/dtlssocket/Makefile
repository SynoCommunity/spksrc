PKG_NAME = DTLSSocket
# Version must match requirement of homeassistant package
PKG_VERS = 0.1.19
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/d/dtlssocket
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://git.fslab.de/jkonra2m/tinydtls-cython
COMMENT  = DTLSSocket is a Cython wrapper for tinydtls with a Socket like interface.
LICENSE  = Eclipse Public License 1.0

PRE_CONFIGURE_TARGET = dtlssocket_pre_configure

include ../../mk/spksrc.common.mk

ifeq ($(call version_le, $(TC_GCC), 5),1)
ADDITIONAL_CFLAGS = -std=c99
endif

include ../../mk/spksrc.python-wheel.mk

.PHONY: dtlssocket_pre_configure
dtlssocket_pre_configure:
	@$(MSG) DTLSSocket patch setup.py to call configure to cross compile
	@$(RUN) sed -i.bak 's%"\./configure"%"\./configure --host=$(TC_TARGET) --build=i686-pc-linux"%g' setup.py
