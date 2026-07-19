PKG_NAME = rubberband
PKG_VERS = 4.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/breakfastquay/rubberband/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://breakfastquay.com/rubberband/
COMMENT  = An audio time-stretching and pitch-shifting library and utility program.
LICENSE  = GPL-2.0 license

# Needs gcc >= 7.5: needs C++17, i.e. gcc 7 or newer.
MIN_GCC_VERSION = 7.5

include ../../mk/spksrc.cross-meson.mk
