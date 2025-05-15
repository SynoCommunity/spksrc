PKG_NAME = urbackup-client
PKG_VERS = 2.5.25
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://hndl.urbackup.org/Client/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS).0

DEPENDS = cross/openssl3 cross/zlib cross/zstd cross/cryptopp

# compiler too old (urbackupcommon/WebSocketPipe.h)
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

HOMEPAGE = https://www.urbackup.org/
COMMENT  = UrBackup is an easy to setup open source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time.
LICENSE  = AGPL 3+

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-headless
CONFIGURE_ARGS += --with-zlib=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-crypto-prefix=$(STAGING_INSTALL_PREFIX)

ADDITIONAL_CPPFLAGS = -O
ADDITIONAL_CXXFLAGS = -O -D_FILE_OFFSET_BITS=64 -Wno-unused-result -Wno-deprecated-declarations

POST_INSTALL_TARGET = urbackup-client_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: urbackup-client_post_install
urbackup-client_post_install:
	@$(MSG) Link executable in sbin to bin for DSM7 compatibility
	@cd $(STAGING_INSTALL_PREFIX)/bin && ln -sf ../sbin/urbackupclientbackend .
