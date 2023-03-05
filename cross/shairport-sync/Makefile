PKG_NAME = shairport-sync
PKG_VERS = 3.3.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mikebrady/shairport-sync/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/libtool cross/libconfig cross/popt cross/libdaemon
DEPENDS += cross/mbedtls
DEPENDS += cross/alsa-lib
DEPENDS += cross/soxr
DEPENDS += cross/libsndfile

HOMEPAGE = https://github.com/mikebrady/shairport-sync
COMMENT  = AirPlay audio player. Shairport Sync adds multi-room capability with Audio Synchronisation. Requires USB soundcard or speakers.
LICENSE  = Please refer to the individual source files for licenses.

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --with-libdaemon
CONFIGURE_ARGS += --with-metadata
CONFIGURE_ARGS += --with-ssl=mbedtls
CONFIGURE_ARGS += --with-tinysvcmdns
CONFIGURE_ARGS += --with-external-mdns
CONFIGURE_ARGS += --with-soxr
CONFIGURE_ARGS += --with-alsa

include ../../mk/spksrc.archs.mk
ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
# convolution filter requires -std=c++11
CONFIGURE_ARGS += --with-convolution
endif

CONFIGURE_ARGS += --sysconfdir=$(INSTALL_PREFIX_VAR)

PRE_CONFIGURE_TARGET = shairport-sync_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: shairport-sync_pre_configure
shairport-sync_pre_configure:
	$(RUN) autoreconf -i -f
