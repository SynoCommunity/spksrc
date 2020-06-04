PKG_NAME = urbackup-server
PKG_VERS = 2.4.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://hndl.urbackup.org/Server/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/curl cross/openssl cross/zlib

HOMEPAGE = https://www.urbackup.org/
COMMENT  = UrBackup is an easy to setup open source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time.
LICENSE  = GNU GPL

CONFIGURE_ARGS = --enable-packaging --enable-embedded-cryptopp --with-zlib=$(STAGING_INSTALL_PREFIX) #--without-crypto --without-zlib --without-mail 
GNU_CONFIGURE = 1
ADDITIONAL_CXXFLAGS = -Os
ADDITIONAL_CFLAGS = -Os


INSTALL_TARGET = urbackup_install



include ../../mk/spksrc.cross-cc.mk

.PHONY: urbackup_install
urbackup_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) # PREFIX=$(INSTALL_PREFIX)
	

