PKG_NAME = opencore-amr
PKG_VERS = 0.1.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://sourceforge.net/projects/opencore-amr/
COMMENT  = Implementation of Adaptive Multi Rate Narrowband and Wideband (AMR-NB and AMR-WB) speech codec.
LICENSE  = Apache License 2.0

GNU_CONFIGURE = 1

# configure falls back on its own -O2 only when CFLAGS is unset, and spksrc
# always sets it: without a level of its own, the library is built -O0.
ADDITIONAL_CFLAGS = -O2
ADDITIONAL_CXXFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk

