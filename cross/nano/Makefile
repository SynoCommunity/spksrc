PKG_NAME = nano
PKG_VERS = 8.7
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.nano-editor.org/dist/v$(firstword $(subst ., ,$(PKG_VERS)))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw

HOMEPAGE = https://www.nano-editor.org
COMMENT  = nano is a text editor for Unix-like computing systems or operating environments using a command line interface.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

# 32-bit archs require glibc >= 2.34 (i.e. DSM 7.2) to support 64 bit timestamps
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-year2038
else ifeq ($(call version_ge, $(TC_GLIBC), 2.34),1)
CONFIGURE_ARGS += --enable-year2038
endif
