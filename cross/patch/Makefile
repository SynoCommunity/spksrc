PKG_NAME = patch
PKG_VERS = 2.7.6
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://savannah.gnu.org/projects/patch/
COMMENT  = Utility for modifying/upgrading files
LICENSE  = GPLv3+

PRE_CONFIGURE_TARGET = $(PKG_NAME)_pre_configure
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-silent-rules

PATCHES_LEVEL = 1


include ../../mk/spksrc.cross-cc.mk

.PHONY: $(PKG_NAME)_pre_configure
$(PKG_NAME)_pre_configure:
	$(RUN) autoreconf -i -f -v

