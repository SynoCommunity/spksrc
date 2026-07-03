PKG_NAME = librist
PKG_VERS = v0.2.10
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://code.videolan.org/rist/librist/-/archive/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://code.videolan.org/rist/librist
COMMENT  = A library that can be used to easily add the RIST protocol to your application.
LICENSE  = BSD 2-Clause "Simplified" License

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

include ../../mk/spksrc.common.mk

# evansport-6.1: error: PIC register clobbered by ‘ebx’ in ‘asm’
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
ifeq ($(findstring $(ARCH),evansport),$(ARCH))
ADDITIONAL_CFLAGS = -O0
endif
endif

include ../../mk/spksrc.cross-meson.mk
