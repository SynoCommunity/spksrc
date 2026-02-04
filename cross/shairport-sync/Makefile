PKG_NAME = shairport-sync
PKG_VERS = 4.3.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mikebrady/shairport-sync/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Classic AirPlay mode (AirPlay 2 requires NQPTP which needs root for ports 319/320)
DEPENDS = cross/alsa-lib cross/libconfig cross/libdaemon cross/openssl3 cross/popt cross/soxr

HOMEPAGE = https://github.com/mikebrady/shairport-sync
COMMENT  = AirPlay audio player for streaming from Apple devices
LICENSE  = GPL

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --with-alsa
CONFIGURE_ARGS += --with-dummy
CONFIGURE_ARGS += --with-pipe
CONFIGURE_ARGS += --with-ssl=openssl
CONFIGURE_ARGS += --with-soxr
CONFIGURE_ARGS += --with-libdaemon
CONFIGURE_ARGS += --with-tinysvcmdns
CONFIGURE_ARGS += --without-configfiles
CONFIGURE_ARGS += --with-piddir=/var/packages/shairport-sync/var
CONFIGURE_ARGS += ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes

PRE_CONFIGURE_TARGET = shairport_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: shairport_pre_configure
shairport_pre_configure:
	$(RUN) autoreconf -i -f
