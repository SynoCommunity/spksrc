PKG_NAME = libzen
PKG_VERS = 0.4.37
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/MediaArea/ZenLib/archive/v$(PKG_VERS)
PKG_DIR = ZenLib-$(PKG_VERS)/Project/GNU/Library

DEPENDS =

HOMEPAGE = https://github.com/MediaArea/ZenLib
COMMENT  = Small C++ derivate classes to have an easier life.
LICENSE  =

PRE_CONFIGURE_TARGET = libzen_pre_configure
GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-shared

include ../../mk/spksrc.cross-cc.mk

libzen_pre_configure:
	$(RUN) ; ./autogen.sh
