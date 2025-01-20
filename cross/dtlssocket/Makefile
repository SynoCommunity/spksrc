PKG_NAME = dtlssocket
PKG_VERS = 0.2.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/97/b6/702c4197c37c7036d0b7d67a2963c83a4b7098525959566dc6e2284c9f89
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
	@$(MSG) configure tinydtls to cross compile
	@$(RUN) sed -i.bak 's%"\./configure"%"\./configure --host=$(TC_TARGET) --build=i686-pc-linux"%g' setup.py
