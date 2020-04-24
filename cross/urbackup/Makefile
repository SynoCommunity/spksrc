PKG_NAME = urbackup-server
PKG_VERS = 2.4.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
<<<<<<< HEAD
<<<<<<< HEAD
PKG_DIST_SITE = https://hndl.urbackup.org/Server/$(PKG_VERS)
=======
PKG_DIST_SITE = https://hndl.urbackup.org/Server/2.4.12
>>>>>>> e697f224... add urbackup support
=======
PKG_DIST_SITE = https://hndl.urbackup.org/Server/$(PKG_VERS)
>>>>>>> aa831382... many improvements
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/curl cross/openssl cross/zlib

HOMEPAGE = https://www.urbackup.org/
COMMENT  = UrBackup is an easy to setup open source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time.
LICENSE  = GNU GPL

CONFIGURE_ARGS = --enable-packaging --enable-embedded-cryptopp --with-zlib=$(STAGING_INSTALL_PREFIX) #--without-crypto --without-zlib --without-mail 
GNU_CONFIGURE = 1
ADDITIONAL_CXXFLAGS = -Os
ADDITIONAL_CFLAGS = -Os


INSTALL_TARGET = myInstall



include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
<<<<<<< HEAD
<<<<<<< HEAD
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) # PREFIX=$(INSTALL_PREFIX)
=======
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)
>>>>>>> e697f224... add urbackup support
=======
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) # PREFIX=$(INSTALL_PREFIX)
>>>>>>> aa831382... many improvements
	

