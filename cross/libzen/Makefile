PKG_NAME = libzen
PKG_VERS = 0.4.39
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/MediaArea/ZenLib/archive
PKG_DIST_FILE = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIR = ZenLib-$(PKG_VERS)/Project/GNU/Library

DEPENDS =

HOMEPAGE = https://github.com/MediaArea/ZenLib
COMMENT  = Small C++ derivate classes to have an easier life.
LICENSE  = 3-Clause BSD

PRE_CONFIGURE_TARGET = libzen_pre_configure
GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-shared

include ../../mk/spksrc.cross-cc.mk

.PHONY: libzen_pre_configure
libzen_pre_configure:
	$(RUN) ; ./autogen.sh
