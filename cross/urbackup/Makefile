PKG_NAME = urbackup-server
PKG_VERS = 2.4.13
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://hndl.urbackup.org/Server/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/curl cross/zlib cross/openssl cross/cryptopp

HOMEPAGE = https://www.urbackup.org/
COMMENT  = UrBackup is an easy to setup open source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time.
LICENSE  = AGPL-3.0

CONFIGURE_ARGS = --enable-packaging
CONFIGURE_ARGS += --with-zlib=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-crypto-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --enable-embedded-zstd

GNU_CONFIGURE = 1
ADDITIONAL_CXXFLAGS = -Os
ADDITIONAL_CFLAGS = -Os

include ../../mk/spksrc.cross-cc.mk
