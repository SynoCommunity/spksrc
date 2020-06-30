PKG_NAME = shairport-sync
PKG_VERS = 3.3.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mikebrady/shairport-sync/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libtool cross/libconfig cross/popt cross/libdaemon cross/openssl cross/alsa-lib

HOMEPAGE = https://github.com/mikebrady/shairport-sync
COMMENT  = AirPlay audio player. Shairport Sync adds multi-room capability with Audio Synchronisation. Requires USB soundcard or speakers.
LICENSE  = https://github.com/mikebrady/shairport-sync/blob/master/COPYING

GNU_CONFIGURE = 1

CONFIGURE_ARGS += --with-alsa --with-ssl=openssl --with-tinysvcmdns --with-libdaemon
CONFIGURE_ARGS += ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes

PRE_CONFIGURE_TARGET = shairport-sync_pre_configure


include ../../mk/spksrc.cross-cc.mk

.PHONY: shairport-sync_pre_configure
shairport-sync_pre_configure:
	$(RUN) autoreconf -i -f
