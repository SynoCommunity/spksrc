PKG_NAME = pixman
PKG_VERS = 0.38.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.cairographics.org/releases/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpng

HOMEPAGE = https://www.cairographics.org
COMMENT  = Pixman is a low-level software library for pixel manipulation, providing features such as image compositing and trapezoid rasterization.
LICENSE  = MIT

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-gtk

PRE_COMPILE_TARGET = pixman_pre_compile


ifeq ($(ARCH),hi3535)
CONFIGURE_ARGS += --disable-arm-iwmmxt
endif


include ../../mk/spksrc.cross-cc.mk

.PHONY: pixman_pre_compile
pixman_pre_compile:
	@$(MSG) "- patch generated Makefile to skip compilation of demos and test code"
	@$(RUN) sed -i 's|SUBDIRS = pixman demos test|SUBDIRS = pixman|g' ./Makefile
