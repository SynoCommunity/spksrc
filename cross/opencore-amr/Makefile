PKG_NAME = opencore-amr
PKG_VERS = 0.1.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/opencore-amr/files/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/Distrotech/opencore-amr/
COMMENT  = OpenCORE Adaptive Multi Rate (AMR) speech codec library implementation.
LICENSE  = Apache 2

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = myPreConfigure

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --enable-gcc-armv5
endif

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoreconf -i -f

