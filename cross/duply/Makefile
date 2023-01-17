PKG_NAME = duply
PKG_VERS = 2.0.1
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/ftplicity/files/duply%20%28simple%20duplicity%29/2.0.x
PKG_DIR = $(PKG_NAME)_$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://duply.net
COMMENT  = duply is a frontend for the mighty duplicity magic. duplicity is a python based shell application that makes encrypted incremental backups to remote storages. Different backends like ftp, sftp, imap, s3 and others are supported. See duplicity manpage for a complete list of backends and features.
LICENSE  = GPLv3


CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_NAME)
