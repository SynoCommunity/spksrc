PKG_NAME = zimg
PKG_VERS = 3.0.4
PKG_EXT = tar.gz
PKG_DIST_NAME = release-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sekrit-twc/zimg/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-release-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/sekrit-twc/zimg
COMMENT  = The "z" library implements the commonly required image processing basics of scaling, colorspace conversion, and depth conversion.
LICENSE  = WTFPL license

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = zimg_pre_configure

include ../../mk/spksrc.cross-cc.mk

ifeq ($(call version_lt, $(TCVERSION), 7.0),1)
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --disable-simd
endif
endif

.PHONY: zimg_pre_configure
zimg_pre_configure:
	@$(RUN) ./autogen.sh
