PKG_NAME = libwebp
PKG_VERS = 1.2.4
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/webmproject/libwebp/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/xz cross/libtiff cross/libjpeg cross/libpng cross/giflib

HOMEPAGE = https://developers.google.com/speed/webp
COMMENT  = WebP codec: library to encode and decode images in WebP format.
LICENSE  = https://github.com/webmproject/libwebp/blob/master/COPYING

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = libwebp_pre_configure
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --enable-libwebpdecoder

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.common.mk
# newer gcc require definition of -std=c11
ifneq ($(call version_lt,$(TCVERSION),6.1)$(call version_ge,$(TCVERSION),3.0),11)
ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
ADDITIONAL_CPPFLAGS += -std=c11
endif
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: libwebp_pre_configure
libwebp_pre_configure:
	$(RUN) ./autogen.sh
