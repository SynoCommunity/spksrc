PKG_NAME = liblc3
PKG_VERS = 1.1.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/google/liblc3/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/google/liblc3/
COMMENT  = LC3 and LC3 Plus are audio codecs designed for low-latency audio transport.
LICENSE  = Apache-2.0 license

# Minimum GCC version required is >= 4.9
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt, $(TC_GCC), 5),1)
ADDITIONAL_CFLAGS = -std=c99
endif

include ../../mk/spksrc.cross-meson.mk
