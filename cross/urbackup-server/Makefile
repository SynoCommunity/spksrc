PKG_NAME = urbackup-server
PKG_VERS = 2.5.33
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://hndl.urbackup.org/Server/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3 cross/zlib cross/zstd cross/cryptopp cross/curl

# compiler too old (urbackupcommon/WebSocketPipe.h)
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

HOMEPAGE = https://www.urbackup.org/
COMMENT  = UrBackup is an easy to setup open source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time.
LICENSE  = AGPL-3.0

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-packaging
CONFIGURE_ARGS += --with-zlib=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-crypto-prefix=$(STAGING_INSTALL_PREFIX)

ADDITIONAL_CFLAGS = -O
ADDITIONAL_CXXFLAGS = -O -Wno-unused-result -Wno-deprecated-declarations

include ../../mk/spksrc.cross-cc.mk
