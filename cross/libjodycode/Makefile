PKG_NAME = libjodycode
PKG_VERS = 3.1.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://codeberg.org/jbruchon/libjodycode/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = https://www.jodybruchon.com/software/
COMMENT  = Shared code used by several utilities written by Jody Bruchon.
LICENSE  = MIT

CONFIGURE_TARGET = nop
INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)

ifeq ($(findstring $(ARCH),x86),$(ARCH))
# for x86-5.2
ADDITIONAL_CFLAGS = -DNO_SSE2 -DNO_AVX2
endif

include ../../mk/spksrc.cross-cc.mk
