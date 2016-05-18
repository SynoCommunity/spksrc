PKG_NAME = vo-amrwbenc
PKG_EXT = tar.gz
PKG_VERS = 0.1.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/opencore-amr/files/vo-amrwbenc
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)/

DEPENDS =

HOMEPAGE = https://github.com/msstorsjo/vo-amrwbenc/
COMMENT  = VisualOn AMR-WB encoder library
LICENSE  = Apache 2

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = myPreConfigure

ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --enable-armv5e
endif

ifeq ($(findstring $(ARCH), $(ARM7_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --enable-armv7neon
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoreconf -i -f
