PKG_NAME = shairport-sync
PKG_VERS = 4.3.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mikebrady/shairport-sync/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Common dependencies for both Classic AirPlay and AirPlay 2
DEPENDS  = cross/alsa-lib cross/libconfig cross/libdaemon cross/openssl3 cross/popt cross/soxr

# AirPlay 2 dependencies (enabled by default, requires NQPTP daemon and root access)
# Set SHAIRPORT_AIRPLAY2=0 to build Classic AirPlay only mode
# AirPlay 2 requires avahi (provided by cross/avahi-headers which compiles against DSM system avahi)
SHAIRPORT_AIRPLAY2 ?= 1
ifeq ($(SHAIRPORT_AIRPLAY2),1)
BUILD_DEPENDS = native/xxd
XXD_PATH = $(abspath $(PWD)/../../native/xxd/work-native/install/usr/local/bin)
ENV += PATH=$(XXD_PATH):$$PATH
DEPENDS += cross/nqptp
DEPENDS += cross/libplist
DEPENDS += cross/libsodium
DEPENDS += cross/libgcrypt
DEPENDS += cross/ffmpeg6-audio
DEPENDS += cross/libuuid
DEPENDS += cross/avahi-headers
endif

HOMEPAGE = https://github.com/mikebrady/shairport-sync
COMMENT  = AirPlay audio player for streaming from Apple devices
LICENSE  = GPL

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --with-alsa
CONFIGURE_ARGS += --with-dummy
CONFIGURE_ARGS += --with-pipe
CONFIGURE_ARGS += --with-ssl=openssl
CONFIGURE_ARGS += --with-soxr
CONFIGURE_ARGS += --with-metadata
CONFIGURE_ARGS += --with-libdaemon
CONFIGURE_ARGS += --without-configfiles
CONFIGURE_ARGS += --with-piddir=/var/packages/shairport-sync/var
CONFIGURE_ARGS += ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes

ifeq ($(SHAIRPORT_AIRPLAY2),1)
# AirPlay 2 mode - use system avahi for proper dual-service mDNS registration
CONFIGURE_ARGS += --with-airplay-2
CONFIGURE_ARGS += --with-avahi
else
# Classic AirPlay mode - use built-in mDNS
CONFIGURE_ARGS += --with-tinysvcmdns
endif

PRE_CONFIGURE_TARGET = shairport_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: shairport_pre_configure
shairport_pre_configure:
	$(RUN) autoreconf -i -f
