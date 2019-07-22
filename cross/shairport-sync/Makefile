PKG_NAME = shairport-sync
PKG_VERS = 2.3.11
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mikebrady/shairport-sync/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libtool cross/libconfig cross/popt cross/libdaemon cross/openssl cross/alsa-lib

HOMEPAGE = https://github.com/mikebrady/shairport-sync
COMMENT  = Use Synology NAS as an Airplay receiver. Requires USB soundcard or speakers.
LICENSE  = https://raw.githubusercontent.com/mikebrady/shairport-sync/$(PKG_VERS)/LICENSES

GNU_CONFIGURE = 1

CONFIGURE_ARGS += --with-alsa --with-ssl=openssl --with-tinysvcmdns --without-configfiles --with-piddir=$(INSTALL_DIR)/var
CONFIGURE_ARGS += ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes

PRE_CONFIGURE_TARGET = myPreConfigure

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoreconf -i -f

