PKG_NAME = uchardet
PKG_VERS = 0.0.6
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.freedesktop.org/software/uchardet/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.freedesktop.org/wiki/Software/uchardet/
COMMENT  = uchardet is an encoding detector library, which takes a sequence of bytes in an unknown character encoding without any additional information, and attempts to determine the encoding of the text. Returned encoding names are iconv-compatible.
LICENSE  = Mozilla 1.1, GPLv2+, LGPLv2.1+

CONFIGURE_TARGET = uchardet_configure
CMAKE_ARGS = -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX) -DCMAKE_BUILD_TYPE=Release


include ../../mk/spksrc.cross-cc.mk

.PHONY: uchardet_configure
uchardet_configure:
	$(RUN) cmake $(CMAKE_ARGS)
