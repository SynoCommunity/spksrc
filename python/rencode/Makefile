PKG_NAME = rencode
PKG_VERS = 1.0.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/r/rencode
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/aresch/rencode
COMMENT  = Rencode is an object serialization library similar to bencode from the Bittorrent project. Rencode is a complete rewrite in Cython to attempt to increase the performance over the pure Python module.
LICENSE  = License (GPLv3)

include ../../mk/spksrc.common.mk

ifeq ($(call version_le, $(TC_GCC), 5),1)
ADDITIONAL_CFLAGS = -std=c99
endif

include ../../mk/spksrc.python-wheel.mk
