PKG_NAME = libxml2
PKG_VERS = 2.12.9
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/libxml2/$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = https://gitlab.gnome.org/GNOME/libxml2/-/wikis/home
COMMENT  = Libxml2 is the XML C parser and toolkit developed for the Gnome project (but usable outside of the Gnome platform).
LICENSE  = MIT

CMAKE_ARGS  = -DLIBXML2_WITH_PYTHON=OFF
CMAKE_ARGS += -DLIBXML2_WITH_LZMA=OFF
CMAKE_ARGS += -DLIBXML2_WITH_TESTS=OFF
CMAKE_ARGS += -DLIBXML2_WITH_DEBUG=OFF
CMAKE_ARGS += -DHAVE_LIBREADLINE=0

# adjust prefix in xml2-config
POST_INSTALL_TARGET = libxml2_post_install

include ../../mk/spksrc.cross-cmake.mk

.PHONY: libxml2_post_install
libxml2_post_install:
	sed -i -e 's|^prefix=$(INSTALL_PREFIX)$$|prefix=$(STAGING_INSTALL_PREFIX)|' $(STAGING_INSTALL_PREFIX)/bin/xml2-config
