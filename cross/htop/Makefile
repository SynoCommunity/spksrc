PKG_NAME = htop
PKG_VERS = 3.0.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/htop-dev/htop/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

UNSUPPORTED_ARCHS = powerpc ppc824x

DEPENDS = cross/ncursesw

HOMEPAGE = https://hisham.hm/htop/
COMMENT  = An interactive process viewer for Linux. The package is intended for DSM-5.0 or earlier where it\'s not available.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = htop_pre_configure

CONFIGURE_ARGS  = --enable-unicode
CONFIGURE_ARGS += HTOP_NCURSESW6_CONFIG_SCRIPT=$(STAGING_INSTALL_PREFIX)/bin/ncursesw6-config
CONFIGURE_ARGS += --disable-dependency-tracking

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# use clock_gettime of librt
ADDITIONAL_LDFLAGS = -lrt
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: htop_pre_configure
htop_pre_configure:
	@$(RUN) ./autogen.sh
	@$(MSG) "patch configure file to find ncursesw"
	$(RUN) sed -e 's/-lncursesw6/-lncursesw/' -i ./configure
