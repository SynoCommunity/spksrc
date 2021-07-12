PKG_NAME = urbackup-client
PKG_VERS = 2.4.10
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://hndl.urbackup.org/Client/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS).0

DEPENDS = cross/zlib cross/zstd cross/cryptopp cross/openssl

HOMEPAGE = https://www.urbackup.org/
COMMENT  = UrBackup is an easy to setup open source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time.
LICENSE  = AGPL-3.0

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-headless
CONFIGURE_ARGS += --with-zlib=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-crypto-prefix=$(STAGING_INSTALL_PREFIX)
ADDITIONAL_CXXFLAGS = -O2 -D_FILE_OFFSET_BITS=64

include ../../mk/spksrc.cross-cc.mk
